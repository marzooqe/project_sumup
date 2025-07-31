import openpyxl
import csv
import os

def convert_xlsx_to_csv(xlsx_path, output_folder="."):
    wb = openpyxl.load_workbook(xlsx_path, data_only=True)
    sheet = wb.active

    base_name = os.path.splitext(os.path.basename(xlsx_path))[0]
    csv_path = os.path.join(output_folder, f"{base_name}.csv")

    with open(csv_path, 'w', newline='', encoding='utf-8') as csv_file:
        writer = csv.writer(csv_file, quoting=csv.QUOTE_MINIMAL)
        for row in sheet.iter_rows(values_only=True):
            clean_row = [str(cell).strip() if cell is not None else "" for cell in row]
            writer.writerow(clean_row)

    print(f"✅ Converted: {xlsx_path} → {csv_path}")
    return csv_path

def convert_all_xlsx_in_folder(input_folder, output_folder="."):
    for file in os.listdir(input_folder):
        if file.endswith(".xlsx"):
            xlsx_path = os.path.join(input_folder, file)
            convert_xlsx_to_csv(xlsx_path, output_folder)

# --- Usage ---
if __name__ == "__main__":
    input_folder = "./raw_data"    # Folder containing .xlsx files
    output_folder = "."     # Folder where .csv will be saved

    os.makedirs(output_folder, exist_ok=True)
    convert_all_xlsx_in_folder(input_folder, output_folder)
