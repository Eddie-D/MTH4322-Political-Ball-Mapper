import pandas as pd

pd.set_option('display.max_rows', None)

ge = pd.read_csv("GE2010-Formatted.csv")
av = pd.read_csv("./Alternate-Vote.csv")
l = len(ge)

df = pd.merge(
    ge,
    av,
    left_on="Constituency Name",
    right_on="Areas",
    how="inner",
    indicator=True
)

# Filter for rows that are NOT in both tables
# mismatches_df = df[df['_merge'] != 'both']
# mismatches_df = mismatches_df[["Constituency Name", "Areas", "_merge"]]

# Display the mismatches
# print(mismatches_df)

print(df)
print(f"{l - len(df)} mismatches")
# mismatches_df.to_csv("./mismatches.csv")
df.to_csv("./all.csv", index=False)
