import os

i=1
#path = '/home/yash/Sem5/SMAI/SMAI-Project/Dataset/pami2009_release/pami09_preRelease/Objects/cricket_ball/'
for line in open('filenames.txt', 'r'):
	first = line
	second = 'image' + str(i) + '.png'
	i = i + 1
#	print str(str('mv ') + str(str(first[0:len(first)-1]) + ' '+str(second)))
	os.system(str(str("mv ") + str(first[0:len(first)-1]) + str(" ") + str(second)))
#	print str("mv ") + str(first) + str(" ") + str(second)
