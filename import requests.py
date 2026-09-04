import requests
from bs4 import BeautifulSoup

def extract_table_data(url):
    """
    Takes a Google Doc URL (must be 'Published to the web' or publicly accessible),
    parses the HTML table, and returns the x, y, and character arrays.
    """
    response = requests.get(url)
    response.raise_for_status()  # Ensure the request was successful

    soup = BeautifulSoup(response.text, 'html.parser')
    
    # Find the first table in the document
    table = soup.find('table')
    if not table:
        raise ValueError("No table found in the provided document.")

    xv, yv, sv = [], [], []
    
    # Extract rows from the table
    rows = table.find_all('tr')
    
    # Skip the header row (assuming row 0 is headers like "x-coordinate", "Character", "y-coordinate")
    for row in rows[1:]:
        cols = row.find_all('td')
        
        # Ensure the row has exactly 3 columns
        if len(cols) == 3:            # Adjust the indices below if the table order is different
            x = int(cols[0].text.strip())
            char = cols[1].text.strip()
            y = int(cols[2].text.strip())
            
            xv.append(x)
            sv.append(char)
            yv.append(y)
            
    return xv, yv, sv

def print_message(url):
    """
    Main function to fetch data and print the 2D array message.
    """
    xv, yv, sv = extract_table_data(url)
    
    ncols = max(xv) + 1
    nrows = max(yv) + 1
    
    message = [[" "] * ncols for _ in range(nrows)]
    
    for x, y, s in zip(xv, yv, sv):
        message[y][x] = s
        
    # 5. Print the message row by row
    for row in message:
        print("".join(row))
        

# Example usage:
url = "https://docs.google.com/document/d/e/2PACX-1vSvM5gDlNvt7npYHhp_XfsJvuntUhq184By5xO_pA4b_gCWeXb6dM6ZxwN8rE6S4ghUsCj2VKR21oEP/pub"

print_message(url)