# ==================================================================
# Credit Card Validator
#
# This program validate credit card numbers with below rules:
# 1. It must start with a digit 4, 5 or 6
# 2. It must contain exactly 16 digits.
# 3. It must only consist of digits (0-9).
# 4. It may have digits in groups of 4, separated by one hyphen "-".
# 5. It must NOT use any other separator like ' ' , '_', etc.
# 6. It must NOT have 4 or more consecutive repeated digits.
# 
# ==================================================================

import re
print ("Enter no. of Credit-card Number to validate : ")

for _ in range(int(input())):
    print ("Enter Credit-card Number ", _+1 , " : ")
    x = input()
    fst_match = re.search(r'^[456]\d{3}(-?)\d{4}\1\d{4}\1\d{4}$',x) # validates Rule # 1 to 5
    if fst_match:
        str_rem_hyp = "".join(fst_match.group(0).split('-'))
        #print ('Processed String : ',str_rem_hyp)
        cons_nos_match = re.search(r'(\d)\1{3,}',str_rem_hyp) # validates Rule # 6
        if cons_nos_match:
            print ('Invalid, due to 4 or more consectuive digits')
        else:
            print ('Valid')
    else:
        print ('Invalid')