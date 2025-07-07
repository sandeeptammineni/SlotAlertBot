import time
import asyncio
import undetected_chromedriver as uc

from selenium.webdriver.common.by import By
from telegram import Bot

# Configuration
TELEGRAM_TOKEN = "8117470985:AAGUZ1VYL494ZI3w5ekZgJem2zbpsV2y2QE"
CHAT_ID = 1091525485
URL = "https://checkvisaslots.com/latest-us-visa-availability.html"
INTERVAL = 300  # seconds between checks

def get_browser():
    return uc.Chrome(headless=True)


def get_hyderabad_f1_data(driver):
    driver.get(URL)
    time.sleep(5)  # Allow JS to load
    rows = driver.find_elements(By.XPATH, "//table//tr")
    hyderabad_rows = []

    for row in rows:
        cells = row.find_elements(By.TAG_NAME, "td")
        if len(cells) >= 6:
            location = cells[0].text.strip().upper()
            visa_type = cells[1].text.strip().upper()
            if "HYDERABAD" in location and "F-1" in visa_type:
                data = {
                    "location": location,
                    "visa_type": visa_type,
                    "earliest": cells[2].text.strip(),
                    "available": cells[3].text.strip(),
                    "last_seen": cells[4].text.strip(),
                    "relative_time": cells[5].text.strip()
                }
                hyderabad_rows.append(data)
    return hyderabad_rows

def format_msg(rows):
    msg = "F-1 Hyderabad Slot Update:\n"
    for r in rows:
        msg += (f"{r['location']} | {r['visa_type']} | "
                f"Earliest: {r['earliest']} | "
                f"Available: {r['available']} | "
                f"Seen: {r['last_seen']} ({r['relative_time']})\n")
    return msg

async def main():
    bot = Bot(TELEGRAM_TOKEN)
    last_sent = None
    driver = get_browser()

    try:
        while True:
            print("Checking at", time.ctime())
            try:
                rows = get_hyderabad_f1_data(driver)
                if rows:
                    message = format_msg(rows)
                    if message != last_sent:
                        print("Sending Telegram alert...")
                        await bot.send_message(chat_id=CHAT_ID, text=message)
                        last_sent = message
                    else:
                        print("No change in data.")
                else:
                    print("No Hyderabad F-1 data found.")
            except Exception as e:
                print("Error during check:", e)
                await bot.send_message(chat_id=CHAT_ID, text=f"Error: {e}")
            await asyncio.sleep(INTERVAL)
    finally:
        driver.quit()

if __name__ == "__main__":
    asyncio.run(main())
