from itertools import permutations
from collections import Counter

digitCount = 3 #determines max range of numbers, 3 will be 0-999

compare = lambda x, y: Counter(x) == Counter(y) #Compare arrays
list_to_num = lambda x: int(''.join(str(digit) for digit in x)) #Convert list to number
convert_to_list = lambda x: [int(ch) for ch in (str(x).zfill(digitCount))] #Convert to list
trailing_zeros = lambda x, y: int(str(x).ljust(y, '0'))

def main():
	"""
	Loop through all numbers in range and test to determine if the digit pairs
	create arithmetic permutations so that two whole numbers and their
	combined value make use of the same digits.
	"""
	all = list(range(0,trailing_zeros(1, digitCount+1))) #Get all numbers from 0-999
	for num in all:
		numList = convert_to_list(num)
		for p in permutations(numList): #loop through all permutations
			resultList = convert_to_list(num + list_to_num(p)) #get result of original list + p
			if compare(numList, resultList): #if all digits in original are in result they are arithmetic permutations
				print(str(numList) + ' + ' + str(p) + ' = ' + str(resultList))
	input('Complete') #stop console from closing

if __name__ == "__main__": main()
