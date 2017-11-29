label = open('latest_good_3.txt','r')
labeled = open('labeledFile.txt','r')
labelSet =  label.readlines()
labeledSet = labeled.readlines()
for i in labeledSet:
	for j in labelSet:
		if j == i:
			print i

