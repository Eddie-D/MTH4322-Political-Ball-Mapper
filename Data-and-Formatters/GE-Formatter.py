import pandas as pd

df = pd.read_csv("./GE2010-results.csv")
pd.set_option('display.max_rows', None)

# Remove the Northern Irish rows:
oldLen = len(df)
df = (df[df["Region"] != "Northern Ireland"])
print(f"Removed: {oldLen - len(df)} constituencies")

print(df.columns)
df = df.drop(["Press Association Reference", "Election Year", "Electorate"], axis=1)
print(df.columns)

keepColumns = ["Constituency Name", "Region", "Votes", "Con", "Lab", "LD"]

# Frame to sum
sf = df.drop(keepColumns, axis=1)

df = df[keepColumns]
df["Other"] = sf.sum(axis=1)
# print(df["Other"])

# Calculate percentage votes for each party
party_cols = ["Con", "Lab", "LD", "Other"]
for col in party_cols:
    df[col] = (df[col] / df["Votes"]) * 100

# Rename columns to indicate percentages
df = df.rename(columns={"Con": "Percentage.Con", "Lab": "Percentage.Lab", "LD": "Percentage.LD", "Other": "Percentage.Other"})

df = df.drop(["Region", "Votes"], axis=1)

df.to_csv("./GE2010-Formatted.csv", index=False)