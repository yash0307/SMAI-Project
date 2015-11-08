import os

i=1
path = '/home/yash/Sem5/SMAI/SMAI-Project/Dataset/pami2009_release/pami09_preRelease/Objects/cricket_ball/'
for line in open('filenames.txt', 'r'):
	first = path + line
	second = 'image' + str(i) + '.png'
	i = i + 1
	second = path +"cricket_ball/"+ second
	os.system(str("mv ") + str(first) + str(" ") + str(second))
#	print str("mv ") + str(first) + str(" ") + str(second)
