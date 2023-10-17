#!/usr/bin/env python
# coding: utf-8

# In[1]:


import os, shutil


# In[9]:


path = r"C:/Users/Ammo/Desktop/Python/"


# In[12]:


file_name = os.listdir(path)


# In[19]:


folder_names = ['excel files','image files', 'text files']


for loop in range(0,3):
    if not os.path.exists(path + folder_names[loop]):
        #print(path + folder_names[loop])
        os.makedirs(path + folder_names[loop])
        
for file in file_name:
    if ".xlsx" in file and not os.path.exists(path + 'excel files/' + file):
        shutil.move(path + file , path + 'excel files/' + file)
    elif ".jpg" in file and not os.path.exists(path + 'image files/' + file):
        shutil.move(path + file , path + 'image files/' + file)
    elif ".docx" in file and not os.path.exists(path + 'text files/' + file):
        shutil.move(path + file , path + 'text files/' + file)


# In[18]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




