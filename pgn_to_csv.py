#	This program is really inefficient, but
#	it did what it needed to and that's all
# 	i wanted.

import re

def get_column(line):
	parse = re.search("\\[(.*) \"(.*)\"\\]", line, re.IGNORECASE)
	if parse:
		return parse.group(1)
	else:
		print(f"Issue parsing column name: line[{line}]")
		return ""

def get_column_and_value(line):
	parse = re.search("\\[(.*) \"(.*)\"\\]", line, re.IGNORECASE)
	if parse:
		return parse.group(1), parse.group(2)
	else:
		print(f"Issue parsing column name: line[{line}]")
		return ""


columns = [] # this is going to be the overarching columns. contains string, add moves at the end

#this is super inefficient but we're going to get the columns first
counter = 0
games_file = "lichess_db_standard_rated_2021-01.1.1.pgn"
with open(games_file) as infile:
	for line in infile:
		if line[0] == '[':
			column = get_column(line)
			if column not in columns:
				columns.insert(counter, column)
				print(f"Adding column [{column}]")
			counter += 1
		elif line[0] == '1':
			counter = 0


counter = 0
row = ""
temp_game = {}

seperator = "|"

with open(f"{games_file}.txt", "w") as outfile:
	for col in columns:
		row = row + col + seperator
	row = row + "Moves" + "\n"
	outfile.write(row)
	row = ""
	with open(games_file) as infile:
		for line in infile:
			if seperator in line:
				print(f"Seperation will not work, line {line} contain seperator {seperator} somewhere")
				exit()
				
			if line[0] == '[':
				column, value = get_column_and_value(line)
				if column not in columns:
					print(f"Issue with line [{line}]")
				temp_game.update({column: value})
			elif line[0] == '1':
				for col in columns:
					row = row + temp_game.get(col, "") + seperator
				row = row + line + "\n"
				outfile.write(row)
				row = ""



print(columns)        