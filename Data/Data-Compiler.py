import pandas as pd

pd.set_option('display.max_rows', None)

ge = pd.read_csv("GE2010-Formatted.csv")
av = pd.read_csv("./AV-Formatted.csv")
qual = pd.read_csv("Qualifications-raw.csv")
age = pd.read_csv("age-raw.csv")
l = len(ge)

# Merge first 2
df = pd.merge(
    ge,
    av,
    left_on="Constituency Name",
    right_on="Areas",
    how="inner",
    indicator=True
)

# https://www.youtube.com/watch?v=bC6tngl0PTI
df.rename(columns={"Con": "Cons"}, inplace=True)

print(f"{l - len(df)} mismatches")
# Add Qualifications
df = pd.merge(
    df,
    qual,
    left_on="Constituency Name",
    right_on="parliamentary constituency 2010"
)
print(f"{l - len(df)} mismatches")

# Add ages
df = pd.merge(
    df,
    age,
    left_on="Constituency Name",
    right_on="geography"
)

print(f"{l - len(df)} mismatches")

# Filter for rows that are NOT in both tables
# mismatches_df = df[df['_merge'] != 'both']
# mismatches_df = mismatches_df[["Constituency Name", "Areas", "_merge"]]

# Display the mismatches
# print(mismatches_df)

df = df.drop(labels=["Region", "Areas", "Votes", "Percentage No", "Percentage Turnout", "_merge", "parliamentary constituency 2010", "All categories", 'Schoolchildren and full-time students: Age 18 and over', 'date', 'geography', 'geography code', 'Rural Urban', 'Age: All usual residents; measures: Value', 'Age: Age 0 to 4; measures: Value', 'Age: Age 5 to 7; measures: Value', 'Age: Age 8 to 9; measures: Value', 'Age: Age 10 to 14; measures: Value', 'Age: Age 15; measures: Value', 'Age: Age 16 to 17; measures: Value'], axis=1)

print(df)
print(f"{l - len(df)} mismatches")
# mismatches_df.to_csv("./mismatches.csv")
df.to_csv("./all.csv", index=False)
