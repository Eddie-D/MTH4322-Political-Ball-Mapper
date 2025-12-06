import pandas as pd

pd.set_option('display.max_rows', None)

ge = pd.read_csv("GE2010-Formatted.csv")
av = pd.read_csv("./AV-Formatted.csv")
l = len(ge)

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

# Filter for rows that are NOT in both tables
# mismatches_df = df[df['_merge'] != 'both']
# mismatches_df = mismatches_df[["Constituency Name", "Areas", "_merge"]]

# Display the mismatches
# print(mismatches_df)

print(df)
print(f"{l - len(df)} mismatches")
# mismatches_df.to_csv("./mismatches.csv")
df.to_csv("./all.csv", index=False)
