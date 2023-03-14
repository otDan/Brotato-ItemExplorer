class_name StringComparer
extends Node


func _check_similarity(a: String, b: String, different_character_number: int) -> bool:
	var similar = false
	if a.find(b) != -1:
		similar = true
	if levenshtein_distance(a, b) <= different_character_number:
		similar = true
	return similar


func levenshtein_distance(a: String, b: String) -> int:
	var matrix = []
	for i in range(a.length() + 1):
		var row = []
		for j in range(b.length() + 1):
			row.append(0)
		matrix.append(row)

	for i in range(a.length() + 1):
		matrix[i][0] = i

	for j in range(b.length() + 1):
		matrix[0][j] = j

	for j in range(1, b.length() + 1):
		for i in range(1, a.length() + 1):
			if a[i - 1] == b[j - 1]:
				matrix[i][j] = matrix[i - 1][j - 1]
			else:
				matrix[i][j] = min(matrix[i - 1][j], matrix[i][j - 1])
				matrix[i][j] = min(matrix[i][j], matrix[i - 1][j - 1]) + 1

	return matrix[a.length()][b.length()]
