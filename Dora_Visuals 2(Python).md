Visualization #4: Top Fast Food Brand Presence by Geographies (Python)


```python
import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
import folium
from folium.plugins import FastMarkerCluster
import re
import os
for dirname, _, filenames in os.walk('/kaggle/input'):
    for filename in filenames:
        print(os.path.join(dirname, filename))
import plotly
import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots

pd.set_option('display.max_rows', 500)
```


```python
#Import the dataset and keep relevant columns only
data=pd.read_csv('Datafiniti_Fast_Food_Restaurants.csv')
data.drop(columns=['keys'],inplace=True)
data.head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>dateAdded</th>
      <th>dateUpdated</th>
      <th>address</th>
      <th>categories</th>
      <th>city</th>
      <th>country</th>
      <th>latitude</th>
      <th>longitude</th>
      <th>name</th>
      <th>postalCode</th>
      <th>province</th>
      <th>sourceURLs</th>
      <th>websites</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>AVwcmSyZIN2L1WUfmxyw</td>
      <td>2015-10-19T23:47:58Z</td>
      <td>2018-06-26T03:00:14Z</td>
      <td>800 N Canal Blvd</td>
      <td>American Restaurant and Fast Food Restaurant</td>
      <td>Thibodaux</td>
      <td>US</td>
      <td>29.814697</td>
      <td>-90.814742</td>
      <td>SONIC Drive In</td>
      <td>70301</td>
      <td>LA</td>
      <td>https://foursquare.com/v/sonic-drive-in/4b7361...</td>
      <td>https://locations.sonicdrivein.com/la/thibodau...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>AVwcmSyZIN2L1WUfmxyw</td>
      <td>2015-10-19T23:47:58Z</td>
      <td>2018-06-26T03:00:14Z</td>
      <td>800 N Canal Blvd</td>
      <td>Fast Food Restaurants</td>
      <td>Thibodaux</td>
      <td>US</td>
      <td>29.814697</td>
      <td>-90.814742</td>
      <td>SONIC Drive In</td>
      <td>70301</td>
      <td>LA</td>
      <td>https://foursquare.com/v/sonic-drive-in/4b7361...</td>
      <td>https://locations.sonicdrivein.com/la/thibodau...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>AVwcopQoByjofQCxgfVa</td>
      <td>2016-03-29T05:06:36Z</td>
      <td>2018-06-26T02:59:52Z</td>
      <td>206 Wears Valley Rd</td>
      <td>Fast Food Restaurant</td>
      <td>Pigeon Forge</td>
      <td>US</td>
      <td>35.803788</td>
      <td>-83.580553</td>
      <td>Taco Bell</td>
      <td>37863</td>
      <td>TN</td>
      <td>https://www.yellowpages.com/pigeon-forge-tn/mi...</td>
      <td>http://www.tacobell.com,https://locations.taco...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>AVweXN5RByjofQCxxilK</td>
      <td>2017-01-03T07:46:11Z</td>
      <td>2018-06-26T02:59:51Z</td>
      <td>3652 Parkway</td>
      <td>Fast Food</td>
      <td>Pigeon Forge</td>
      <td>US</td>
      <td>35.782339</td>
      <td>-83.551408</td>
      <td>Arby's</td>
      <td>37863</td>
      <td>TN</td>
      <td>http://www.yellowbook.com/profile/arbys_163389...</td>
      <td>http://www.arbys.com,https://locations.arbys.c...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>AWQ6MUvo3-Khe5l_j3SG</td>
      <td>2018-06-26T02:59:43Z</td>
      <td>2018-06-26T02:59:43Z</td>
      <td>2118 Mt Zion Parkway</td>
      <td>Fast Food Restaurant</td>
      <td>Morrow</td>
      <td>US</td>
      <td>33.562738</td>
      <td>-84.321143</td>
      <td>Steak 'n Shake</td>
      <td>30260</td>
      <td>GA</td>
      <td>https://foursquare.com/v/steak-n-shake/4bcf77a...</td>
      <td>http://www.steaknshake.com/locations/23851-ste...</td>
    </tr>
  </tbody>
</table>
</div>




```python
most_similar_edited = [["Carl's Jr.", "Carl's Jr", 'Carls Jr'],
 ["McDonald's", "Mc Donald's", 'Mcdonalds', 'McDonalds'],
 ['Cook-Out', 'Cook Out', 'CookOut'],
 ["Steak 'n Shake",
  "STEAK 'N SHAKE",
  'Steak N Shake',
  'Steak n Shake',
  "Steak 'N Shake"],
 ['QDOBA Mexican Eats', 'Qdoba Mexican Eats'],
 ['Burger King', 'Burger King®'],
 ["Hardee's", 'Hardees'],
 ['Taco Time', 'TacoTime'],
 ["Arby's", 'Arbys'],
 ['Chick-fil-A', 'Chick-Fil-A', 'ChickfilA'],
 ['Subway', 'SUBWAY'],
 ['Kfc', 'KFC'],
 ["Jack's", 'Jacks'],
 ['Sonic Drive-In',
  'SONIC Drive-In',
  'SONIC Drive In',
  'Sonic DriveIn',
  'Sonic Drive-in'],
 ["Church's Chicken", 'Churchs Chicken'],
 ['Big Boys', 'Big Boy'],
 ['Dairy Queen', 'Dairy queen'],
 ['Guthries', "Guthrie's"],
 ['Chick-Fil-A', 'Chick-fil-A', 'ChickfilA'],
 ["Wendy's", 'Wendys'],
 ["Jimmy John's", 'Jimmy Johns'],
 ['Dairy Queen Grill Chill', 'Dairy Queen Grill & Chill'],
 ["Moe's Southwest Grill", 'Moes Southwest Grill'],
 ["Domino's Pizza", 'Dominos Pizza'],
 ["Rally's", 'Rallys'],
 ['Full Moon Bar-B-Que', 'Full Moon Bar B Que'],
 ["Guthrie's", 'Guthries'],
 ["McAlister's Deli", "Mcalister's Deli", 'McAlisters Deli'],
 ["Jason's Deli", 'Jasons Deli'],
 ['KFC', 'Kfc', 'KFC Kentucky Fried Chicken', 'KFC - Kentucky Fried Chicken'],
 ['Popeyes Louisiana Kitchen', "Popeye's Louisiana Kitchen"],
 ["Long John Silver's", 'Long John Silvers'],
 ['BLIMPIE', 'Blimpie'],
 ['Five Guys Burgers Fries', 'Five Guys Burgers & Fries'],
 ['SUBWAY', 'Subway'],
 ['Dairy Queen Grill & Chill', 'Dairy Queen Grill Chill'],
 ['Potbelly Sandwich Works', 'Pot Belly Sandwich Works'],
 ["Charley's Grilled Subs", 'Charleys Grilled Subs'],
 ["Jersey Mike's Subs", 'Jersey Mikes Subs'],
 ['In-N-Out Burger', 'InNOut Burger'],
 ["Culver's", "CULVER'S", 'Culvers'],
 ["Famous Dave's", 'Famous Daves'],
 ["Freddy's Frozen Custard Steakburgers",
  'Freddys Frozen Custard Steakburgers',
  "Freddy's Frozen Custard & Steakburgers"],
 ['Cook Out', 'Cook-Out', 'CookOut'],
 ['TacoTime', 'Taco Time'],
 ['Hooters', 'Roosters'],
 ['BurgerFi', 'Burgerfi'],
 ["Chen's Restaurant", "Chan's Restaurant"],
 ['Taco Del Mar', 'Taco del Mar'],
 ['SONIC Drive-In',
  'Sonic Drive-In',
  'SONIC Drive In',
  'Sonic DriveIn',
  'Sonic Drive-in'],
 ['Ciscos Taqueria', "Cisco's Taqueria"],
 ['China King', 'China Lin'],
 ["Bojangles' Famous Chicken 'n Biscuits",
  'Bojangles Famous Chicken n Biscuits'],
 ["Dominic's of New York", 'Dominics of New York'],
 ["Papa John's Pizza", 'Papa Johns Pizza'],
 ['Chanellos Pizza', 'Chanello’s Pizza'],
 ["Fazoli's", 'Fazolis'],
 ['Wing Street', 'Wingstreet'],
 ["George's Gyros Spot", "George's Gyros Spot 2"],
 ['Taco Johns', "Taco John's"],
 ['RUNZA', 'Runza'],
 ['Bru Burger Bar', 'Grub Burger Bar'],
 ["Taco John's", 'Taco Johns'],
 ["Bob's Burger Brew", "Bob's Burgers Brew", "Bob's Burgers Brew", "Bob's Burger Brew"],
 ['Best Burgers', 'Best Burger'],
 ['Burgermaster', 'Burger Master'],
 ["Dick's Drive-In", "DK's Drive-In"],
 ["Charley's Grill Spirits", "Charley's Grill & Spirits"],
 ['Tom Drive-in', "Tom's Drive-In"],
 ["Fox's Pizza Den", 'Foxs Pizza Den'],
 ["Mc Donald's", "McDonald's", 'Mcdonalds', 'McDonalds'],
 ['Taco CASA', 'Taco Casa'],
 ["Mcalister's Deli", "McAlister's Deli", 'McAlisters Deli'],
 ['Saras Too', "Sara's Too"],
 ['Backyard Burgers', 'Back Yard Burgers'],
 ["CULVER'S", "Culver's", 'Culvers'],
 ["Simple Simon's Pizza", 'Simple Simons Pizza'],
 ['China Sea', 'China Star', 'China Bear'],
 ["Dino's Drive In", "Dan's Drive In"],
 ["STEAK 'N SHAKE",
  "Steak 'n Shake",
  'Steak N Shake',
  'Steak n Shake',
  "Steak 'N Shake"],
 ['Stanfields Steak House', "Stanfield's Steakhouse"],
 ['Wingstreet', 'Wing Street'],
 ["Big Billy's Burger Joint", 'Big Billys Burger Joint'],
 ['Big Boy', 'Big Boys'],
 ["Frisch's Big Boy Restaurant", "1 Frisch's Big Boy Restaurant", 
  "40 Frisch's Big Boy Restaurant", "1 Frisch's Big Boy Restaurant",
  "90 Frisch's Big Boy Restaurant"],
 ['Fireplace Restaurant Lounge', 'Fireplace Restaurant & Lounge'],
 ["Carl's Jr", "Carl's Jr.", 'Carls Jr'],
 ["Rick's on the River", 'Ricks on the River'],
 ['Grub Burger Bar', 'Bru Burger Bar'],
 ["Franky's", "Grandy's"],
 ['Gyro X-Press', 'Gyro Express'],
 ['Dominos Pizza', "Domino's Pizza"],
 ["Pietro's Pizza Gallery of Games", "Pietro's Pizza & Gallery of Games"],
 ['Burrtio Amigos', 'Burrito Amigos'],
 ["Albee's Ny Gyros", "Albee's NY Gyros"],
 ['Gyro Stop', 'Gyro Spot'],
 ['Nicholas Restaurant', "Nicholas' Restaurant"],
 ['Mcdonalds', "McDonald's", "Mc Donald's", 'McDonalds'],
 ['Burgerfi', 'BurgerFi'],
 ["Ryan's", 'Ryans'],
 ['Taste of Buffalo Pizzeria', 'Taste Of Buffalo Pizzeria'],
 ['Bad Daddys Burger Bar', "Bad Daddy's Burger Bar"],
 ["Zaxby's", "Arby's"],
 ["Topper's Pizza", 'Toppers Pizza'],
 ['C J Drive In', 'C & J Drive In'],
 ['Full Moon Bar B Que', 'Full Moon Bar-B-Que'],
 ['China Lin', 'China King'],
 ["Raising Cane's Chicken Fingers", 'Raising Canes Chicken Fingers'],
 ["Mary's Pizza Shack", 'Marys Pizza Shack'],
 ['Peking Chinese Restaurants', 'Peking Chinese Restaurant'],
 ['Arbys', "Arby's"],
 ['SONIC Drive In',
  'Sonic Drive-In',
  'SONIC Drive-In',
  'Sonic DriveIn',
  'Sonic Drive-in'],
 ['Hardees', "Hardee's"],
 ['McDonalds', "McDonald's", "Mc Donald's", 'Mcdonalds'],
 ['Wendys', "Wendy's"],
 ['Papa Johns Pizza', "Papa John's Pizza"],
 ["George's Gyros Spot 2", "George's Gyros Spot"],
 ['ChickfilA', 'Chick-fil-A', 'Chick-Fil-A'],
 ['Rallys', "Rally's"],
 ['C & J Drive In', 'C J Drive In'],
 ['Steak N Shake',
  "Steak 'n Shake",
  "STEAK 'N SHAKE",
  'Steak n Shake',
  "Steak 'N Shake"],
 ["Popeye's Louisiana Kitchen", 'Popeyes Louisiana Kitchen'],
 ["DJ's Drive-In", "DK's Drive-In"],
 ["Dan's Drive In", "Dino's Drive In"],
 ['Best Burger', 'Best Burgers', 'Beef Burger'],
 ['Jimmy Johns', "Jimmy John's"],
 ['BaskinRobbins', 'Baskin-Robbins', 'Baskin Robbins'],
 ['Carls Jr', "Carl's Jr.", "Carl's Jr"],
 ['WG Grinders', 'Wg Grinders'],
 ['McAlisters Deli', "McAlister's Deli", "Mcalister's Deli"],
 ['Fazolis', "Fazoli's"],
 ['Marys Pizza Shack', "Mary's Pizza Shack"],
 ['Bojangles Famous Chicken n Biscuits',
  "Bojangles' Famous Chicken 'n Biscuits"],
 ['Jacks', "Jack's"],
 ["Hardee's/red Burrito", 'Hardees Red Burrito', "Hardee's/Red Burrito"],
 ['Captain Ds', "Captain D'S"],
 ['Mr Hero', 'Mr. Hero'],
 ["Chan's Restaurant", "Chen's Restaurant"],
 ['Ritters Frozen Custard', "Ritter's Frozen Custard"],
 ['Hot Dog on a Stick', 'Hot Dog On A Stick'],
 ['Jersey Mikes Subs', "Jersey Mike's Subs"],
 ['AW Restaurants',
  'Aw Restaurants',
  'AWRestaurants',
  'A W Restaurant',
  'AW Restaurant',
  'Jam Restaurants'],
 ['Long John Silvers', "Long John Silver's"],
 ["Rally's Hamburgers", 'Rallys Hamburgers'],
 ['HomeTown Buffet', 'Hometown Buffet'],
 ['Back Yard Burgers', 'Backyard Burgers'],
 ['Hardees Red Burrito', "Hardee's/red Burrito", "Hardee's/Red Burrito"],
 ["DK's Drive-In", "Dick's Drive-In", "DJ's Drive-In", "K's Drive In"],
 ['Baskin-Robbins', 'BaskinRobbins', 'Baskin Robbins'],
 ['Churchs Chicken', "Church's Chicken"],
 ['Blimpie', 'BLIMPIE'],
 ['Foxs Pizza Den', "Fox's Pizza Den"],
 ['Steak n Shake',
  "Steak 'n Shake",
  "STEAK 'N SHAKE",
  'Steak N Shake',
  "Steak 'N Shake"],
 ['Rallys Hamburgers', "Rally's Hamburgers"],
 ['Sonic DriveIn',
  'Sonic Drive-In',
  'SONIC Drive-In',
  'SONIC Drive In',
  'Sonic Drive-in'],
 ['Famous Daves', "Famous Dave's"],
 ['Beef Burger', 'Best Burger'],
 ['Dominics of New York', "Dominic's of New York"],
 ['Z-Pizza', 'zpizza'],
 ['KFC - Kentucky Fried Chicken', 'KFC Kentucky Fried Chicken'],
 ["Rockne's", 'Rocknes'],
 ["Hardee's/Red Burrito", "Hardee's/red Burrito", 'Hardees Red Burrito'],
 ['Aw Restaurants',
  'AW Restaurants',
  'AWRestaurants',
  'A W Restaurant',
  'AW Restaurant',
  'Jam Restaurants'],
 ['AWRestaurants', 'AW Restaurants', 'Aw Restaurants', 'AW Restaurant'],
 ["Hardee's Restaurant", "Hardee's Restaurants"],
 ["Hardee's Restaurants", "Hardee's Restaurant"],
 ["Stanfield's Steakhouse", 'Stanfields Steak House'],
 ['Dunkin Donuts', "Dunkin' Donuts"],
 ['Einstein Bros. Bagels', 'Einstein Bros Bagels'],
 ['Simple Simons Pizza', "Simple Simon's Pizza"],
 ['A W Restaurant', 'AW Restaurants', 'Aw Restaurants', 'AW Restaurant'],
 ['Einstein Bros Bagels', 'Einstein Bros. Bagels'],
 ['Roosters', 'Hooters'],
 ['Culvers', "Culver's", "CULVER'S"],
 ['Slice of Life', 'Slice Of Life'],
 ['Jasons Deli', "Jason's Deli"],
 ['Wg Grinders', 'WG Grinders'],
 ['Charleys Grilled Subs', "Charley's Grilled Subs"],
 ['Freddys Frozen Custard Steakburgers',
  "Freddy's Frozen Custard Steakburgers"],
 ['Moes Southwest Grill', "Moe's Southwest Grill"],
 ['CookOut', 'Cook-Out', 'Cook Out'],
 ['Peking Chinese Restaurant', 'Peking Chinese Restaurants'],
 ['InNOut Burger', 'In-N-Out Burger'],
 ["Nicholas' Restaurant", 'Nicholas Restaurant'],
 ['Chanello’s Pizza', 'Chanellos Pizza'],
 ['Ryans', "Ryan's"],
 ['Burger King®', 'Burger King'],
 ['Toppers Pizza', "Topper's Pizza"],
 ["Albee's NY Gyros", "Albee's Ny Gyros"],
 ['Qdoba Mexican Eats', 'QDOBA Mexican Eats'],
 ['Runza', 'RUNZA'],
 ['Slice Of Life', 'Slice of Life'],
 ['Mai-Tai Restaurant', 'Mai Tai Restaurant'],
 ['Gyro Express', 'Gyro X-Press'],
 ['zpizza', 'Z-Pizza'],
 ['Raising Canes Chicken Fingers', "Raising Cane's Chicken Fingers"],
 ['Rocknes', "Rockne's"],
 ['LL Hawaiian Barbecue', 'L L Hawaiian Barbecue', 'L L Hawaiian Barbeque'],
 ['Dairy queen', 'Dairy Queen'],
 ['Blakes Lotaburger', "Blake's Lotaburger"],
 ['Emidio & Sons Italian Restaurant', 'Emidio Sons Italian Restaurant'],
 ['Taste Of Buffalo Pizzeria', 'Taste of Buffalo Pizzeria'],
 ['L L Hawaiian Barbecue',
  'LL Hawaiian Barbecue',
  'L L Hawaiian Barbeque',
  'L & L Hawaiian Barbecue'],
 ['Killer Burgers', 'Killer Burger'],
 ["Steak 'N Shake",
  "Steak 'n Shake",
  "STEAK 'N SHAKE",
  'Steak N Shake',
  'Steak n Shake'],
 ['Burrito Amigos', 'Burrtio Amigos'],
 ["Zack's Hamburgers", "Jack's Hamburgers"],
 ['AW Restaurant',
  'AW Restaurants',
  'Aw Restaurants',
  'AWRestaurants',
  'A W Restaurant'],
 ['Jam Restaurants', 'AW Restaurants', 'Aw Restaurants'],
 ['Big Billys Burger Joint', "Big Billy's Burger Joint"],
 ['L L Hawaiian Barbeque', 'LL Hawaiian Barbecue', 'L L Hawaiian Barbecue'],
 ["Ritter's Frozen Custard", 'Ritters Frozen Custard'],
 ["Pietro's Pizza & Gallery of Games", "Pietro's Pizza Gallery of Games"],
 ["K's Drive In", "DK's Drive-In"],
 ['Killer Burger', 'Killer Burgers'],
 ["Dunkin' Donuts", 'Dunkin Donuts'],
 ['Farlows on the Water', "Farlow's On The Water"],
 ['Hometown Buffet', 'HomeTown Buffet'],
 ["Blake's Lotaburger", 'Blakes Lotaburger'],
 ["Jack's Hamburgers", "Zack's Hamburgers"],
 ["Cisco's Taqueria", 'Ciscos Taqueria'],
 ["Grandy's", "Franky's"],
 ["Farlow's On The Water", 'Farlows on the Water'],
 ["Bad Daddy's Burger Bar", 'Bad Daddys Burger Bar'],
 ['Baskin Robbins', 'BaskinRobbins', 'Baskin-Robbins'],
 ["Sara's Too", 'Saras Too'],
 ['T & L Hotdogs', 'T & L Hot Dogs'],
 ["Tom's Drive-In", 'Tom Drive-in'],
 ['Sonic Drive-in',
  'Sonic Drive-In',
  'SONIC Drive-In',
  'SONIC Drive In',
  'Sonic DriveIn'],
 ['Taco Casa', 'Taco CASA'],
 ['Emidio Sons Italian Restaurant', 'Emidio & Sons Italian Restaurant'],
 ['Fireplace Restaurant & Lounge', 'Fireplace Restaurant Lounge'],
 ['Mai Tai Restaurant', 'Mai-Tai Restaurant'],
 ['Ricks on the River', "Rick's on the River"],
 ['Taco del Mar', 'Taco Del Mar'],
 ['Five Guys Burgers & Fries', 'Five Guys Burgers Fries'],
 ['Mr. Hero', 'Mr Hero'],
 ["Captain D'S", 'Captain Ds'],
 ['Gyro Spot', 'Gyro Stop'],
 ["Charley's Grill & Spirits", "Charley's Grill Spirits"],
 ['Hot Dog On A Stick', 'Hot Dog on a Stick'],
 ['L & L Hawaiian Barbecue', 'L L Hawaiian Barbecue'],
 ['Pot Belly Sandwich Works', 'Potbelly Sandwich Works'],
 ['Burger Master', 'Burgermaster'],
 ["Freddy's Frozen Custard & Steakburgers",
  "Freddy's Frozen Custard Steakburgers"]]
```


```python
def sortFirst(val): 
    return val[0]  

# sorts the array in ascending according to 1st element 
most_similar_edited.sort(key = sortFirst)  
most_similar_edited
```




    [['A W Restaurant', 'AW Restaurants', 'Aw Restaurants', 'AW Restaurant'],
     ['AW Restaurant',
      'AW Restaurants',
      'Aw Restaurants',
      'AWRestaurants',
      'A W Restaurant'],
     ['AW Restaurants',
      'Aw Restaurants',
      'AWRestaurants',
      'A W Restaurant',
      'AW Restaurant',
      'Jam Restaurants'],
     ['AWRestaurants', 'AW Restaurants', 'Aw Restaurants', 'AW Restaurant'],
     ["Albee's NY Gyros", "Albee's Ny Gyros"],
     ["Albee's Ny Gyros", "Albee's NY Gyros"],
     ["Arby's", 'Arbys'],
     ['Arbys', "Arby's"],
     ['Aw Restaurants',
      'AW Restaurants',
      'AWRestaurants',
      'A W Restaurant',
      'AW Restaurant',
      'Jam Restaurants'],
     ['BLIMPIE', 'Blimpie'],
     ['Back Yard Burgers', 'Backyard Burgers'],
     ['Backyard Burgers', 'Back Yard Burgers'],
     ["Bad Daddy's Burger Bar", 'Bad Daddys Burger Bar'],
     ['Bad Daddys Burger Bar', "Bad Daddy's Burger Bar"],
     ['Baskin Robbins', 'BaskinRobbins', 'Baskin-Robbins'],
     ['Baskin-Robbins', 'BaskinRobbins', 'Baskin Robbins'],
     ['BaskinRobbins', 'Baskin-Robbins', 'Baskin Robbins'],
     ['Beef Burger', 'Best Burger'],
     ['Best Burger', 'Best Burgers', 'Beef Burger'],
     ['Best Burgers', 'Best Burger'],
     ["Big Billy's Burger Joint", 'Big Billys Burger Joint'],
     ['Big Billys Burger Joint', "Big Billy's Burger Joint"],
     ['Big Boy', 'Big Boys'],
     ['Big Boys', 'Big Boy'],
     ["Blake's Lotaburger", 'Blakes Lotaburger'],
     ['Blakes Lotaburger', "Blake's Lotaburger"],
     ['Blimpie', 'BLIMPIE'],
     ["Bob's Burger Brew",
      "Bob's Burgers Brew",
      "Bob's Burgers Brew",
      "Bob's Burger Brew"],
     ['Bojangles Famous Chicken n Biscuits',
      "Bojangles' Famous Chicken 'n Biscuits"],
     ["Bojangles' Famous Chicken 'n Biscuits",
      'Bojangles Famous Chicken n Biscuits'],
     ['Bru Burger Bar', 'Grub Burger Bar'],
     ['Burger King', 'Burger King®'],
     ['Burger King®', 'Burger King'],
     ['Burger Master', 'Burgermaster'],
     ['BurgerFi', 'Burgerfi'],
     ['Burgerfi', 'BurgerFi'],
     ['Burgermaster', 'Burger Master'],
     ['Burrito Amigos', 'Burrtio Amigos'],
     ['Burrtio Amigos', 'Burrito Amigos'],
     ['C & J Drive In', 'C J Drive In'],
     ['C J Drive In', 'C & J Drive In'],
     ["CULVER'S", "Culver's", 'Culvers'],
     ["Captain D'S", 'Captain Ds'],
     ['Captain Ds', "Captain D'S"],
     ["Carl's Jr", "Carl's Jr.", 'Carls Jr'],
     ["Carl's Jr.", "Carl's Jr", 'Carls Jr'],
     ['Carls Jr', "Carl's Jr.", "Carl's Jr"],
     ["Chan's Restaurant", "Chen's Restaurant"],
     ['Chanellos Pizza', 'Chanello’s Pizza'],
     ['Chanello’s Pizza', 'Chanellos Pizza'],
     ["Charley's Grill & Spirits", "Charley's Grill Spirits"],
     ["Charley's Grill Spirits", "Charley's Grill & Spirits"],
     ["Charley's Grilled Subs", 'Charleys Grilled Subs'],
     ['Charleys Grilled Subs', "Charley's Grilled Subs"],
     ["Chen's Restaurant", "Chan's Restaurant"],
     ['Chick-Fil-A', 'Chick-fil-A', 'ChickfilA'],
     ['Chick-fil-A', 'Chick-Fil-A', 'ChickfilA'],
     ['ChickfilA', 'Chick-fil-A', 'Chick-Fil-A'],
     ['China King', 'China Lin'],
     ['China Lin', 'China King'],
     ['China Sea', 'China Star', 'China Bear'],
     ["Church's Chicken", 'Churchs Chicken'],
     ['Churchs Chicken', "Church's Chicken"],
     ["Cisco's Taqueria", 'Ciscos Taqueria'],
     ['Ciscos Taqueria', "Cisco's Taqueria"],
     ['Cook Out', 'Cook-Out', 'CookOut'],
     ['Cook-Out', 'Cook Out', 'CookOut'],
     ['CookOut', 'Cook-Out', 'Cook Out'],
     ["Culver's", "CULVER'S", 'Culvers'],
     ['Culvers', "Culver's", "CULVER'S"],
     ["DJ's Drive-In", "DK's Drive-In"],
     ["DK's Drive-In", "Dick's Drive-In", "DJ's Drive-In", "K's Drive In"],
     ['Dairy Queen', 'Dairy queen'],
     ['Dairy Queen Grill & Chill', 'Dairy Queen Grill Chill'],
     ['Dairy Queen Grill Chill', 'Dairy Queen Grill & Chill'],
     ['Dairy queen', 'Dairy Queen'],
     ["Dan's Drive In", "Dino's Drive In"],
     ["Dick's Drive-In", "DK's Drive-In"],
     ["Dino's Drive In", "Dan's Drive In"],
     ["Dominic's of New York", 'Dominics of New York'],
     ['Dominics of New York', "Dominic's of New York"],
     ["Domino's Pizza", 'Dominos Pizza'],
     ['Dominos Pizza', "Domino's Pizza"],
     ['Dunkin Donuts', "Dunkin' Donuts"],
     ["Dunkin' Donuts", 'Dunkin Donuts'],
     ['Einstein Bros Bagels', 'Einstein Bros. Bagels'],
     ['Einstein Bros. Bagels', 'Einstein Bros Bagels'],
     ['Emidio & Sons Italian Restaurant', 'Emidio Sons Italian Restaurant'],
     ['Emidio Sons Italian Restaurant', 'Emidio & Sons Italian Restaurant'],
     ["Famous Dave's", 'Famous Daves'],
     ['Famous Daves', "Famous Dave's"],
     ["Farlow's On The Water", 'Farlows on the Water'],
     ['Farlows on the Water', "Farlow's On The Water"],
     ["Fazoli's", 'Fazolis'],
     ['Fazolis', "Fazoli's"],
     ['Fireplace Restaurant & Lounge', 'Fireplace Restaurant Lounge'],
     ['Fireplace Restaurant Lounge', 'Fireplace Restaurant & Lounge'],
     ['Five Guys Burgers & Fries', 'Five Guys Burgers Fries'],
     ['Five Guys Burgers Fries', 'Five Guys Burgers & Fries'],
     ["Fox's Pizza Den", 'Foxs Pizza Den'],
     ['Foxs Pizza Den', "Fox's Pizza Den"],
     ["Franky's", "Grandy's"],
     ["Freddy's Frozen Custard & Steakburgers",
      "Freddy's Frozen Custard Steakburgers"],
     ["Freddy's Frozen Custard Steakburgers",
      'Freddys Frozen Custard Steakburgers',
      "Freddy's Frozen Custard & Steakburgers"],
     ['Freddys Frozen Custard Steakburgers',
      "Freddy's Frozen Custard Steakburgers"],
     ["Frisch's Big Boy Restaurant",
      "1 Frisch's Big Boy Restaurant",
      "40 Frisch's Big Boy Restaurant",
      "1 Frisch's Big Boy Restaurant",
      "90 Frisch's Big Boy Restaurant"],
     ['Full Moon Bar B Que', 'Full Moon Bar-B-Que'],
     ['Full Moon Bar-B-Que', 'Full Moon Bar B Que'],
     ["George's Gyros Spot", "George's Gyros Spot 2"],
     ["George's Gyros Spot 2", "George's Gyros Spot"],
     ["Grandy's", "Franky's"],
     ['Grub Burger Bar', 'Bru Burger Bar'],
     ["Guthrie's", 'Guthries'],
     ['Guthries', "Guthrie's"],
     ['Gyro Express', 'Gyro X-Press'],
     ['Gyro Spot', 'Gyro Stop'],
     ['Gyro Stop', 'Gyro Spot'],
     ['Gyro X-Press', 'Gyro Express'],
     ["Hardee's", 'Hardees'],
     ["Hardee's Restaurant", "Hardee's Restaurants"],
     ["Hardee's Restaurants", "Hardee's Restaurant"],
     ["Hardee's/Red Burrito", "Hardee's/red Burrito", 'Hardees Red Burrito'],
     ["Hardee's/red Burrito", 'Hardees Red Burrito', "Hardee's/Red Burrito"],
     ['Hardees', "Hardee's"],
     ['Hardees Red Burrito', "Hardee's/red Burrito", "Hardee's/Red Burrito"],
     ['HomeTown Buffet', 'Hometown Buffet'],
     ['Hometown Buffet', 'HomeTown Buffet'],
     ['Hooters', 'Roosters'],
     ['Hot Dog On A Stick', 'Hot Dog on a Stick'],
     ['Hot Dog on a Stick', 'Hot Dog On A Stick'],
     ['In-N-Out Burger', 'InNOut Burger'],
     ['InNOut Burger', 'In-N-Out Burger'],
     ["Jack's", 'Jacks'],
     ["Jack's Hamburgers", "Zack's Hamburgers"],
     ['Jacks', "Jack's"],
     ['Jam Restaurants', 'AW Restaurants', 'Aw Restaurants'],
     ["Jason's Deli", 'Jasons Deli'],
     ['Jasons Deli', "Jason's Deli"],
     ["Jersey Mike's Subs", 'Jersey Mikes Subs'],
     ['Jersey Mikes Subs', "Jersey Mike's Subs"],
     ["Jimmy John's", 'Jimmy Johns'],
     ['Jimmy Johns', "Jimmy John's"],
     ["K's Drive In", "DK's Drive-In"],
     ['KFC', 'Kfc', 'KFC Kentucky Fried Chicken', 'KFC - Kentucky Fried Chicken'],
     ['KFC - Kentucky Fried Chicken', 'KFC Kentucky Fried Chicken'],
     ['Kfc', 'KFC'],
     ['Killer Burger', 'Killer Burgers'],
     ['Killer Burgers', 'Killer Burger'],
     ['L & L Hawaiian Barbecue', 'L L Hawaiian Barbecue'],
     ['L L Hawaiian Barbecue',
      'LL Hawaiian Barbecue',
      'L L Hawaiian Barbeque',
      'L & L Hawaiian Barbecue'],
     ['L L Hawaiian Barbeque', 'LL Hawaiian Barbecue', 'L L Hawaiian Barbecue'],
     ['LL Hawaiian Barbecue', 'L L Hawaiian Barbecue', 'L L Hawaiian Barbeque'],
     ["Long John Silver's", 'Long John Silvers'],
     ['Long John Silvers', "Long John Silver's"],
     ['Mai Tai Restaurant', 'Mai-Tai Restaurant'],
     ['Mai-Tai Restaurant', 'Mai Tai Restaurant'],
     ["Mary's Pizza Shack", 'Marys Pizza Shack'],
     ['Marys Pizza Shack', "Mary's Pizza Shack"],
     ["Mc Donald's", "McDonald's", 'Mcdonalds', 'McDonalds'],
     ["McAlister's Deli", "Mcalister's Deli", 'McAlisters Deli'],
     ['McAlisters Deli', "McAlister's Deli", "Mcalister's Deli"],
     ["McDonald's", "Mc Donald's", 'Mcdonalds', 'McDonalds'],
     ['McDonalds', "McDonald's", "Mc Donald's", 'Mcdonalds'],
     ["Mcalister's Deli", "McAlister's Deli", 'McAlisters Deli'],
     ['Mcdonalds', "McDonald's", "Mc Donald's", 'McDonalds'],
     ["Moe's Southwest Grill", 'Moes Southwest Grill'],
     ['Moes Southwest Grill', "Moe's Southwest Grill"],
     ['Mr Hero', 'Mr. Hero'],
     ['Mr. Hero', 'Mr Hero'],
     ['Nicholas Restaurant', "Nicholas' Restaurant"],
     ["Nicholas' Restaurant", 'Nicholas Restaurant'],
     ["Papa John's Pizza", 'Papa Johns Pizza'],
     ['Papa Johns Pizza', "Papa John's Pizza"],
     ['Peking Chinese Restaurant', 'Peking Chinese Restaurants'],
     ['Peking Chinese Restaurants', 'Peking Chinese Restaurant'],
     ["Pietro's Pizza & Gallery of Games", "Pietro's Pizza Gallery of Games"],
     ["Pietro's Pizza Gallery of Games", "Pietro's Pizza & Gallery of Games"],
     ["Popeye's Louisiana Kitchen", 'Popeyes Louisiana Kitchen'],
     ['Popeyes Louisiana Kitchen', "Popeye's Louisiana Kitchen"],
     ['Pot Belly Sandwich Works', 'Potbelly Sandwich Works'],
     ['Potbelly Sandwich Works', 'Pot Belly Sandwich Works'],
     ['QDOBA Mexican Eats', 'Qdoba Mexican Eats'],
     ['Qdoba Mexican Eats', 'QDOBA Mexican Eats'],
     ['RUNZA', 'Runza'],
     ["Raising Cane's Chicken Fingers", 'Raising Canes Chicken Fingers'],
     ['Raising Canes Chicken Fingers', "Raising Cane's Chicken Fingers"],
     ["Rally's", 'Rallys'],
     ["Rally's Hamburgers", 'Rallys Hamburgers'],
     ['Rallys', "Rally's"],
     ['Rallys Hamburgers', "Rally's Hamburgers"],
     ["Rick's on the River", 'Ricks on the River'],
     ['Ricks on the River', "Rick's on the River"],
     ["Ritter's Frozen Custard", 'Ritters Frozen Custard'],
     ['Ritters Frozen Custard', "Ritter's Frozen Custard"],
     ["Rockne's", 'Rocknes'],
     ['Rocknes', "Rockne's"],
     ['Roosters', 'Hooters'],
     ['Runza', 'RUNZA'],
     ["Ryan's", 'Ryans'],
     ['Ryans', "Ryan's"],
     ['SONIC Drive In',
      'Sonic Drive-In',
      'SONIC Drive-In',
      'Sonic DriveIn',
      'Sonic Drive-in'],
     ['SONIC Drive-In',
      'Sonic Drive-In',
      'SONIC Drive In',
      'Sonic DriveIn',
      'Sonic Drive-in'],
     ["STEAK 'N SHAKE",
      "Steak 'n Shake",
      'Steak N Shake',
      'Steak n Shake',
      "Steak 'N Shake"],
     ['SUBWAY', 'Subway'],
     ["Sara's Too", 'Saras Too'],
     ['Saras Too', "Sara's Too"],
     ["Simple Simon's Pizza", 'Simple Simons Pizza'],
     ['Simple Simons Pizza', "Simple Simon's Pizza"],
     ['Slice Of Life', 'Slice of Life'],
     ['Slice of Life', 'Slice Of Life'],
     ['Sonic Drive-In',
      'SONIC Drive-In',
      'SONIC Drive In',
      'Sonic DriveIn',
      'Sonic Drive-in'],
     ['Sonic Drive-in',
      'Sonic Drive-In',
      'SONIC Drive-In',
      'SONIC Drive In',
      'Sonic DriveIn'],
     ['Sonic DriveIn',
      'Sonic Drive-In',
      'SONIC Drive-In',
      'SONIC Drive In',
      'Sonic Drive-in'],
     ["Stanfield's Steakhouse", 'Stanfields Steak House'],
     ['Stanfields Steak House', "Stanfield's Steakhouse"],
     ["Steak 'N Shake",
      "Steak 'n Shake",
      "STEAK 'N SHAKE",
      'Steak N Shake',
      'Steak n Shake'],
     ["Steak 'n Shake",
      "STEAK 'N SHAKE",
      'Steak N Shake',
      'Steak n Shake',
      "Steak 'N Shake"],
     ['Steak N Shake',
      "Steak 'n Shake",
      "STEAK 'N SHAKE",
      'Steak n Shake',
      "Steak 'N Shake"],
     ['Steak n Shake',
      "Steak 'n Shake",
      "STEAK 'N SHAKE",
      'Steak N Shake',
      "Steak 'N Shake"],
     ['Subway', 'SUBWAY'],
     ['T & L Hotdogs', 'T & L Hot Dogs'],
     ['Taco CASA', 'Taco Casa'],
     ['Taco Casa', 'Taco CASA'],
     ['Taco Del Mar', 'Taco del Mar'],
     ["Taco John's", 'Taco Johns'],
     ['Taco Johns', "Taco John's"],
     ['Taco Time', 'TacoTime'],
     ['Taco del Mar', 'Taco Del Mar'],
     ['TacoTime', 'Taco Time'],
     ['Taste Of Buffalo Pizzeria', 'Taste of Buffalo Pizzeria'],
     ['Taste of Buffalo Pizzeria', 'Taste Of Buffalo Pizzeria'],
     ['Tom Drive-in', "Tom's Drive-In"],
     ["Tom's Drive-In", 'Tom Drive-in'],
     ["Topper's Pizza", 'Toppers Pizza'],
     ['Toppers Pizza', "Topper's Pizza"],
     ['WG Grinders', 'Wg Grinders'],
     ["Wendy's", 'Wendys'],
     ['Wendys', "Wendy's"],
     ['Wg Grinders', 'WG Grinders'],
     ['Wing Street', 'Wingstreet'],
     ['Wingstreet', 'Wing Street'],
     ['Z-Pizza', 'zpizza'],
     ["Zack's Hamburgers", "Jack's Hamburgers"],
     ["Zaxby's", "Arby's"],
     ['zpizza', 'Z-Pizza']]




```python
# let's create a dictionary to make name replace easier
match_name_dict = {}
for row in most_similar_edited:
    for similar_word in row:
        match_name_dict[similar_word] = row[0]
match_name_dict
```




    {'A W Restaurant': 'Aw Restaurants',
     'AW Restaurants': 'Jam Restaurants',
     'Aw Restaurants': 'Jam Restaurants',
     'AW Restaurant': 'Aw Restaurants',
     'AWRestaurants': 'Aw Restaurants',
     'Jam Restaurants': 'Jam Restaurants',
     "Albee's NY Gyros": "Albee's Ny Gyros",
     "Albee's Ny Gyros": "Albee's Ny Gyros",
     "Arby's": "Zaxby's",
     'Arbys': 'Arbys',
     'BLIMPIE': 'Blimpie',
     'Blimpie': 'Blimpie',
     'Back Yard Burgers': 'Backyard Burgers',
     'Backyard Burgers': 'Backyard Burgers',
     "Bad Daddy's Burger Bar": 'Bad Daddys Burger Bar',
     'Bad Daddys Burger Bar': 'Bad Daddys Burger Bar',
     'Baskin Robbins': 'BaskinRobbins',
     'BaskinRobbins': 'BaskinRobbins',
     'Baskin-Robbins': 'BaskinRobbins',
     'Beef Burger': 'Best Burger',
     'Best Burger': 'Best Burgers',
     'Best Burgers': 'Best Burgers',
     "Big Billy's Burger Joint": 'Big Billys Burger Joint',
     'Big Billys Burger Joint': 'Big Billys Burger Joint',
     'Big Boy': 'Big Boys',
     'Big Boys': 'Big Boys',
     "Blake's Lotaburger": 'Blakes Lotaburger',
     'Blakes Lotaburger': 'Blakes Lotaburger',
     "Bob's Burger Brew": "Bob's Burger Brew",
     "Bob's Burgers Brew": "Bob's Burger Brew",
     'Bojangles Famous Chicken n Biscuits': "Bojangles' Famous Chicken 'n Biscuits",
     "Bojangles' Famous Chicken 'n Biscuits": "Bojangles' Famous Chicken 'n Biscuits",
     'Bru Burger Bar': 'Grub Burger Bar',
     'Grub Burger Bar': 'Grub Burger Bar',
     'Burger King': 'Burger King®',
     'Burger King®': 'Burger King®',
     'Burger Master': 'Burgermaster',
     'Burgermaster': 'Burgermaster',
     'BurgerFi': 'Burgerfi',
     'Burgerfi': 'Burgerfi',
     'Burrito Amigos': 'Burrtio Amigos',
     'Burrtio Amigos': 'Burrtio Amigos',
     'C & J Drive In': 'C J Drive In',
     'C J Drive In': 'C J Drive In',
     "CULVER'S": 'Culvers',
     "Culver's": 'Culvers',
     'Culvers': 'Culvers',
     "Captain D'S": 'Captain Ds',
     'Captain Ds': 'Captain Ds',
     "Carl's Jr": 'Carls Jr',
     "Carl's Jr.": 'Carls Jr',
     'Carls Jr': 'Carls Jr',
     "Chan's Restaurant": "Chen's Restaurant",
     "Chen's Restaurant": "Chen's Restaurant",
     'Chanellos Pizza': 'Chanello’s Pizza',
     'Chanello’s Pizza': 'Chanello’s Pizza',
     "Charley's Grill & Spirits": "Charley's Grill Spirits",
     "Charley's Grill Spirits": "Charley's Grill Spirits",
     "Charley's Grilled Subs": 'Charleys Grilled Subs',
     'Charleys Grilled Subs': 'Charleys Grilled Subs',
     'Chick-Fil-A': 'ChickfilA',
     'Chick-fil-A': 'ChickfilA',
     'ChickfilA': 'ChickfilA',
     'China King': 'China Lin',
     'China Lin': 'China Lin',
     'China Sea': 'China Sea',
     'China Star': 'China Sea',
     'China Bear': 'China Sea',
     "Church's Chicken": 'Churchs Chicken',
     'Churchs Chicken': 'Churchs Chicken',
     "Cisco's Taqueria": 'Ciscos Taqueria',
     'Ciscos Taqueria': 'Ciscos Taqueria',
     'Cook Out': 'CookOut',
     'Cook-Out': 'CookOut',
     'CookOut': 'CookOut',
     "DJ's Drive-In": "DK's Drive-In",
     "DK's Drive-In": "K's Drive In",
     "Dick's Drive-In": "Dick's Drive-In",
     "K's Drive In": "K's Drive In",
     'Dairy Queen': 'Dairy queen',
     'Dairy queen': 'Dairy queen',
     'Dairy Queen Grill & Chill': 'Dairy Queen Grill Chill',
     'Dairy Queen Grill Chill': 'Dairy Queen Grill Chill',
     "Dan's Drive In": "Dino's Drive In",
     "Dino's Drive In": "Dino's Drive In",
     "Dominic's of New York": 'Dominics of New York',
     'Dominics of New York': 'Dominics of New York',
     "Domino's Pizza": 'Dominos Pizza',
     'Dominos Pizza': 'Dominos Pizza',
     'Dunkin Donuts': "Dunkin' Donuts",
     "Dunkin' Donuts": "Dunkin' Donuts",
     'Einstein Bros Bagels': 'Einstein Bros. Bagels',
     'Einstein Bros. Bagels': 'Einstein Bros. Bagels',
     'Emidio & Sons Italian Restaurant': 'Emidio Sons Italian Restaurant',
     'Emidio Sons Italian Restaurant': 'Emidio Sons Italian Restaurant',
     "Famous Dave's": 'Famous Daves',
     'Famous Daves': 'Famous Daves',
     "Farlow's On The Water": 'Farlows on the Water',
     'Farlows on the Water': 'Farlows on the Water',
     "Fazoli's": 'Fazolis',
     'Fazolis': 'Fazolis',
     'Fireplace Restaurant & Lounge': 'Fireplace Restaurant Lounge',
     'Fireplace Restaurant Lounge': 'Fireplace Restaurant Lounge',
     'Five Guys Burgers & Fries': 'Five Guys Burgers Fries',
     'Five Guys Burgers Fries': 'Five Guys Burgers Fries',
     "Fox's Pizza Den": 'Foxs Pizza Den',
     'Foxs Pizza Den': 'Foxs Pizza Den',
     "Franky's": "Grandy's",
     "Grandy's": "Grandy's",
     "Freddy's Frozen Custard & Steakburgers": "Freddy's Frozen Custard Steakburgers",
     "Freddy's Frozen Custard Steakburgers": 'Freddys Frozen Custard Steakburgers',
     'Freddys Frozen Custard Steakburgers': 'Freddys Frozen Custard Steakburgers',
     "Frisch's Big Boy Restaurant": "Frisch's Big Boy Restaurant",
     "1 Frisch's Big Boy Restaurant": "Frisch's Big Boy Restaurant",
     "40 Frisch's Big Boy Restaurant": "Frisch's Big Boy Restaurant",
     "90 Frisch's Big Boy Restaurant": "Frisch's Big Boy Restaurant",
     'Full Moon Bar B Que': 'Full Moon Bar-B-Que',
     'Full Moon Bar-B-Que': 'Full Moon Bar-B-Que',
     "George's Gyros Spot": "George's Gyros Spot 2",
     "George's Gyros Spot 2": "George's Gyros Spot 2",
     "Guthrie's": 'Guthries',
     'Guthries': 'Guthries',
     'Gyro Express': 'Gyro X-Press',
     'Gyro X-Press': 'Gyro X-Press',
     'Gyro Spot': 'Gyro Stop',
     'Gyro Stop': 'Gyro Stop',
     "Hardee's": 'Hardees',
     'Hardees': 'Hardees',
     "Hardee's Restaurant": "Hardee's Restaurants",
     "Hardee's Restaurants": "Hardee's Restaurants",
     "Hardee's/Red Burrito": 'Hardees Red Burrito',
     "Hardee's/red Burrito": 'Hardees Red Burrito',
     'Hardees Red Burrito': 'Hardees Red Burrito',
     'HomeTown Buffet': 'Hometown Buffet',
     'Hometown Buffet': 'Hometown Buffet',
     'Hooters': 'Roosters',
     'Roosters': 'Roosters',
     'Hot Dog On A Stick': 'Hot Dog on a Stick',
     'Hot Dog on a Stick': 'Hot Dog on a Stick',
     'In-N-Out Burger': 'InNOut Burger',
     'InNOut Burger': 'InNOut Burger',
     "Jack's": 'Jacks',
     'Jacks': 'Jacks',
     "Jack's Hamburgers": "Zack's Hamburgers",
     "Zack's Hamburgers": "Zack's Hamburgers",
     "Jason's Deli": 'Jasons Deli',
     'Jasons Deli': 'Jasons Deli',
     "Jersey Mike's Subs": 'Jersey Mikes Subs',
     'Jersey Mikes Subs': 'Jersey Mikes Subs',
     "Jimmy John's": 'Jimmy Johns',
     'Jimmy Johns': 'Jimmy Johns',
     'KFC': 'Kfc',
     'Kfc': 'Kfc',
     'KFC Kentucky Fried Chicken': 'KFC - Kentucky Fried Chicken',
     'KFC - Kentucky Fried Chicken': 'KFC - Kentucky Fried Chicken',
     'Killer Burger': 'Killer Burgers',
     'Killer Burgers': 'Killer Burgers',
     'L & L Hawaiian Barbecue': 'L L Hawaiian Barbecue',
     'L L Hawaiian Barbecue': 'LL Hawaiian Barbecue',
     'LL Hawaiian Barbecue': 'LL Hawaiian Barbecue',
     'L L Hawaiian Barbeque': 'LL Hawaiian Barbecue',
     "Long John Silver's": 'Long John Silvers',
     'Long John Silvers': 'Long John Silvers',
     'Mai Tai Restaurant': 'Mai-Tai Restaurant',
     'Mai-Tai Restaurant': 'Mai-Tai Restaurant',
     "Mary's Pizza Shack": 'Marys Pizza Shack',
     'Marys Pizza Shack': 'Marys Pizza Shack',
     "Mc Donald's": 'Mcdonalds',
     "McDonald's": 'Mcdonalds',
     'Mcdonalds': 'Mcdonalds',
     'McDonalds': 'Mcdonalds',
     "McAlister's Deli": "Mcalister's Deli",
     "Mcalister's Deli": "Mcalister's Deli",
     'McAlisters Deli': "Mcalister's Deli",
     "Moe's Southwest Grill": 'Moes Southwest Grill',
     'Moes Southwest Grill': 'Moes Southwest Grill',
     'Mr Hero': 'Mr. Hero',
     'Mr. Hero': 'Mr. Hero',
     'Nicholas Restaurant': "Nicholas' Restaurant",
     "Nicholas' Restaurant": "Nicholas' Restaurant",
     "Papa John's Pizza": 'Papa Johns Pizza',
     'Papa Johns Pizza': 'Papa Johns Pizza',
     'Peking Chinese Restaurant': 'Peking Chinese Restaurants',
     'Peking Chinese Restaurants': 'Peking Chinese Restaurants',
     "Pietro's Pizza & Gallery of Games": "Pietro's Pizza Gallery of Games",
     "Pietro's Pizza Gallery of Games": "Pietro's Pizza Gallery of Games",
     "Popeye's Louisiana Kitchen": 'Popeyes Louisiana Kitchen',
     'Popeyes Louisiana Kitchen': 'Popeyes Louisiana Kitchen',
     'Pot Belly Sandwich Works': 'Potbelly Sandwich Works',
     'Potbelly Sandwich Works': 'Potbelly Sandwich Works',
     'QDOBA Mexican Eats': 'Qdoba Mexican Eats',
     'Qdoba Mexican Eats': 'Qdoba Mexican Eats',
     'RUNZA': 'Runza',
     'Runza': 'Runza',
     "Raising Cane's Chicken Fingers": 'Raising Canes Chicken Fingers',
     'Raising Canes Chicken Fingers': 'Raising Canes Chicken Fingers',
     "Rally's": 'Rallys',
     'Rallys': 'Rallys',
     "Rally's Hamburgers": 'Rallys Hamburgers',
     'Rallys Hamburgers': 'Rallys Hamburgers',
     "Rick's on the River": 'Ricks on the River',
     'Ricks on the River': 'Ricks on the River',
     "Ritter's Frozen Custard": 'Ritters Frozen Custard',
     'Ritters Frozen Custard': 'Ritters Frozen Custard',
     "Rockne's": 'Rocknes',
     'Rocknes': 'Rocknes',
     "Ryan's": 'Ryans',
     'Ryans': 'Ryans',
     'SONIC Drive In': 'Sonic DriveIn',
     'Sonic Drive-In': 'Sonic DriveIn',
     'SONIC Drive-In': 'Sonic DriveIn',
     'Sonic DriveIn': 'Sonic DriveIn',
     'Sonic Drive-in': 'Sonic DriveIn',
     "STEAK 'N SHAKE": 'Steak n Shake',
     "Steak 'n Shake": 'Steak n Shake',
     'Steak N Shake': 'Steak n Shake',
     'Steak n Shake': 'Steak n Shake',
     "Steak 'N Shake": 'Steak n Shake',
     'SUBWAY': 'Subway',
     'Subway': 'Subway',
     "Sara's Too": 'Saras Too',
     'Saras Too': 'Saras Too',
     "Simple Simon's Pizza": 'Simple Simons Pizza',
     'Simple Simons Pizza': 'Simple Simons Pizza',
     'Slice Of Life': 'Slice of Life',
     'Slice of Life': 'Slice of Life',
     "Stanfield's Steakhouse": 'Stanfields Steak House',
     'Stanfields Steak House': 'Stanfields Steak House',
     'T & L Hotdogs': 'T & L Hotdogs',
     'T & L Hot Dogs': 'T & L Hotdogs',
     'Taco CASA': 'Taco Casa',
     'Taco Casa': 'Taco Casa',
     'Taco Del Mar': 'Taco del Mar',
     'Taco del Mar': 'Taco del Mar',
     "Taco John's": 'Taco Johns',
     'Taco Johns': 'Taco Johns',
     'Taco Time': 'TacoTime',
     'TacoTime': 'TacoTime',
     'Taste Of Buffalo Pizzeria': 'Taste of Buffalo Pizzeria',
     'Taste of Buffalo Pizzeria': 'Taste of Buffalo Pizzeria',
     'Tom Drive-in': "Tom's Drive-In",
     "Tom's Drive-In": "Tom's Drive-In",
     "Topper's Pizza": 'Toppers Pizza',
     'Toppers Pizza': 'Toppers Pizza',
     'WG Grinders': 'Wg Grinders',
     'Wg Grinders': 'Wg Grinders',
     "Wendy's": 'Wendys',
     'Wendys': 'Wendys',
     'Wing Street': 'Wingstreet',
     'Wingstreet': 'Wingstreet',
     'Z-Pizza': 'zpizza',
     'zpizza': 'zpizza',
     "Zaxby's": "Zaxby's"}




```python
#top fast food restaurant brands in the dataset
data['name']=data.name.str.replace('$','')
data['name']=data.name.str.replace("'",'')
data['name']=data.name.str.lower()    
data['name']=data.name.map(lambda x: re.sub(r'\W+','',x))


Brand_1=data.groupby(['name']).agg({'name':'count'})
Brand_1.columns=['number']
Brand_1=Brand_1.sort_values('number',ascending=False)

# Brand_1.head(10)
Brand_1.nlargest(15,'number').index
```

    /var/folders/09/9q2rkflj5sg0ftxnxx2dpvb40000gn/T/ipykernel_80720/360620811.py:2: FutureWarning:
    
    The default value of regex will change from True to False in a future version. In addition, single character regular expressions will *not* be treated as literal strings when regex=True.
    





    Index(['mcdonalds', 'tacobell', 'subway', 'burgerking', 'arbys', 'wendys',
           'jackinthebox', 'pizzahut', 'chickfila', 'dairyqueen', 'dominospizza',
           'sonicdrivein', 'kfc', 'carlsjr', 'jimmyjohns'],
          dtype='object', name='name')




```python
#split the country into 4 key regions

def market(x):
    
    if x in ('WA','OR','CA','NV','AZ','NM','CO','WY','MT','ID','AK','HI'):
        return "West"
    elif x in ('ND','MN','IA','SD','KS','NE','MO','WI','MI','IL','IN','OH'):
        return "Mid West"
    elif x in ('NY','NJ','PA','CT','RI','MA','ME','NH','VT'):
        return "North East"
    else:
        return "South"

data['region']=data['province'].apply(market)
data.head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>dateAdded</th>
      <th>dateUpdated</th>
      <th>address</th>
      <th>categories</th>
      <th>city</th>
      <th>country</th>
      <th>latitude</th>
      <th>longitude</th>
      <th>name</th>
      <th>postalCode</th>
      <th>province</th>
      <th>sourceURLs</th>
      <th>websites</th>
      <th>region</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>AVwcmSyZIN2L1WUfmxyw</td>
      <td>2015-10-19T23:47:58Z</td>
      <td>2018-06-26T03:00:14Z</td>
      <td>800 N Canal Blvd</td>
      <td>American Restaurant and Fast Food Restaurant</td>
      <td>Thibodaux</td>
      <td>US</td>
      <td>29.814697</td>
      <td>-90.814742</td>
      <td>sonicdrivein</td>
      <td>70301</td>
      <td>LA</td>
      <td>https://foursquare.com/v/sonic-drive-in/4b7361...</td>
      <td>https://locations.sonicdrivein.com/la/thibodau...</td>
      <td>South</td>
    </tr>
    <tr>
      <th>1</th>
      <td>AVwcmSyZIN2L1WUfmxyw</td>
      <td>2015-10-19T23:47:58Z</td>
      <td>2018-06-26T03:00:14Z</td>
      <td>800 N Canal Blvd</td>
      <td>Fast Food Restaurants</td>
      <td>Thibodaux</td>
      <td>US</td>
      <td>29.814697</td>
      <td>-90.814742</td>
      <td>sonicdrivein</td>
      <td>70301</td>
      <td>LA</td>
      <td>https://foursquare.com/v/sonic-drive-in/4b7361...</td>
      <td>https://locations.sonicdrivein.com/la/thibodau...</td>
      <td>South</td>
    </tr>
    <tr>
      <th>2</th>
      <td>AVwcopQoByjofQCxgfVa</td>
      <td>2016-03-29T05:06:36Z</td>
      <td>2018-06-26T02:59:52Z</td>
      <td>206 Wears Valley Rd</td>
      <td>Fast Food Restaurant</td>
      <td>Pigeon Forge</td>
      <td>US</td>
      <td>35.803788</td>
      <td>-83.580553</td>
      <td>tacobell</td>
      <td>37863</td>
      <td>TN</td>
      <td>https://www.yellowpages.com/pigeon-forge-tn/mi...</td>
      <td>http://www.tacobell.com,https://locations.taco...</td>
      <td>South</td>
    </tr>
    <tr>
      <th>3</th>
      <td>AVweXN5RByjofQCxxilK</td>
      <td>2017-01-03T07:46:11Z</td>
      <td>2018-06-26T02:59:51Z</td>
      <td>3652 Parkway</td>
      <td>Fast Food</td>
      <td>Pigeon Forge</td>
      <td>US</td>
      <td>35.782339</td>
      <td>-83.551408</td>
      <td>arbys</td>
      <td>37863</td>
      <td>TN</td>
      <td>http://www.yellowbook.com/profile/arbys_163389...</td>
      <td>http://www.arbys.com,https://locations.arbys.c...</td>
      <td>South</td>
    </tr>
    <tr>
      <th>4</th>
      <td>AWQ6MUvo3-Khe5l_j3SG</td>
      <td>2018-06-26T02:59:43Z</td>
      <td>2018-06-26T02:59:43Z</td>
      <td>2118 Mt Zion Parkway</td>
      <td>Fast Food Restaurant</td>
      <td>Morrow</td>
      <td>US</td>
      <td>33.562738</td>
      <td>-84.321143</td>
      <td>steaknshake</td>
      <td>30260</td>
      <td>GA</td>
      <td>https://foursquare.com/v/steak-n-shake/4bcf77a...</td>
      <td>http://www.steaknshake.com/locations/23851-ste...</td>
      <td>South</td>
    </tr>
  </tbody>
</table>
</div>




```python
#focus on top 7 brands only, McDonalds, Burger King, Taco Bell, Wendys, Arbys, KFC and Subway.
Brands=['mcdonalds', 'burgerking', 'tacobell', 'wendys', 'arbys', 'kfc','subway']
data1=data[data.name.isin(Brands)]

# print(data1.shape)
data1.head(10)

d1=data1.groupby(['region','name']).agg({'name':'count'})
d1.columns=['Stores']
d1.reset_index(inplace=True)
d1.sort_values(['region', 'Stores'], ascending=[True, False], inplace=True)
d1.reset_index(inplace=True)
d1.drop('index',inplace=True,axis=1)

import plotly.graph_objects as go
import plotly.express as px

fig = px.scatter(d1, x="Stores", y="name", color="region",
                 title="Top Fast Food Brands Presence by Region",
                 labels={"Stores":"Store Count"} 
                )

fig.update_layout(
    margin=dict(l=20, r=20, t=25, b=20)
#     paper_bgcolor="LightSteelBlue",
)
fig.show()
```


<div>                            <div id="f88664f9-3dd4-4eec-bb03-07c0424d96c6" class="plotly-graph-div" style="height:525px; width:100%;"></div>            <script type="text/javascript">                require(["plotly"], function(Plotly) {                    window.PLOTLYENV=window.PLOTLYENV || {};                                    if (document.getElementById("f88664f9-3dd4-4eec-bb03-07c0424d96c6")) {                    Plotly.newPlot(                        "f88664f9-3dd4-4eec-bb03-07c0424d96c6",                        [{"hovertemplate":"region=Mid West<br>Store Count=%{x}<br>name=%{y}<extra></extra>","legendgroup":"Mid West","marker":{"color":"#636efa","symbol":"circle"},"mode":"markers","name":"Mid West","orientation":"h","showlegend":true,"x":[438,290,243,232,225,129,47],"xaxis":"x","y":["mcdonalds","tacobell","subway","arbys","burgerking","wendys","kfc"],"yaxis":"y","type":"scatter"},{"hovertemplate":"region=North East<br>Store Count=%{x}<br>name=%{y}<extra></extra>","legendgroup":"North East","marker":{"color":"#EF553B","symbol":"circle"},"mode":"markers","name":"North East","orientation":"h","showlegend":true,"x":[297,138,125,114,72,52,31],"xaxis":"x","y":["mcdonalds","subway","burgerking","wendys","tacobell","arbys","kfc"],"yaxis":"y","type":"scatter"},{"hovertemplate":"region=South<br>Store Count=%{x}<br>name=%{y}<extra></extra>","legendgroup":"South","marker":{"color":"#00cc96","symbol":"circle"},"mode":"markers","name":"South","orientation":"h","showlegend":true,"x":[807,381,301,287,283,275,57],"xaxis":"x","y":["mcdonalds","tacobell","arbys","subway","burgerking","wendys","kfc"],"yaxis":"y","type":"scatter"},{"hovertemplate":"region=West<br>Store Count=%{x}<br>name=%{y}<extra></extra>","legendgroup":"West","marker":{"color":"#ab63fa","symbol":"circle"},"mode":"markers","name":"West","orientation":"h","showlegend":true,"x":[408,289,200,165,110,81,27],"xaxis":"x","y":["mcdonalds","tacobell","burgerking","subway","wendys","arbys","kfc"],"yaxis":"y","type":"scatter"}],                        {"template":{"data":{"bar":[{"error_x":{"color":"#2a3f5f"},"error_y":{"color":"#2a3f5f"},"marker":{"line":{"color":"#E5ECF6","width":0.5},"pattern":{"fillmode":"overlay","size":10,"solidity":0.2}},"type":"bar"}],"barpolar":[{"marker":{"line":{"color":"#E5ECF6","width":0.5},"pattern":{"fillmode":"overlay","size":10,"solidity":0.2}},"type":"barpolar"}],"carpet":[{"aaxis":{"endlinecolor":"#2a3f5f","gridcolor":"white","linecolor":"white","minorgridcolor":"white","startlinecolor":"#2a3f5f"},"baxis":{"endlinecolor":"#2a3f5f","gridcolor":"white","linecolor":"white","minorgridcolor":"white","startlinecolor":"#2a3f5f"},"type":"carpet"}],"choropleth":[{"colorbar":{"outlinewidth":0,"ticks":""},"type":"choropleth"}],"contour":[{"colorbar":{"outlinewidth":0,"ticks":""},"colorscale":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]],"type":"contour"}],"contourcarpet":[{"colorbar":{"outlinewidth":0,"ticks":""},"type":"contourcarpet"}],"heatmap":[{"colorbar":{"outlinewidth":0,"ticks":""},"colorscale":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]],"type":"heatmap"}],"heatmapgl":[{"colorbar":{"outlinewidth":0,"ticks":""},"colorscale":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]],"type":"heatmapgl"}],"histogram":[{"marker":{"pattern":{"fillmode":"overlay","size":10,"solidity":0.2}},"type":"histogram"}],"histogram2d":[{"colorbar":{"outlinewidth":0,"ticks":""},"colorscale":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]],"type":"histogram2d"}],"histogram2dcontour":[{"colorbar":{"outlinewidth":0,"ticks":""},"colorscale":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]],"type":"histogram2dcontour"}],"mesh3d":[{"colorbar":{"outlinewidth":0,"ticks":""},"type":"mesh3d"}],"parcoords":[{"line":{"colorbar":{"outlinewidth":0,"ticks":""}},"type":"parcoords"}],"pie":[{"automargin":true,"type":"pie"}],"scatter":[{"marker":{"colorbar":{"outlinewidth":0,"ticks":""}},"type":"scatter"}],"scatter3d":[{"line":{"colorbar":{"outlinewidth":0,"ticks":""}},"marker":{"colorbar":{"outlinewidth":0,"ticks":""}},"type":"scatter3d"}],"scattercarpet":[{"marker":{"colorbar":{"outlinewidth":0,"ticks":""}},"type":"scattercarpet"}],"scattergeo":[{"marker":{"colorbar":{"outlinewidth":0,"ticks":""}},"type":"scattergeo"}],"scattergl":[{"marker":{"colorbar":{"outlinewidth":0,"ticks":""}},"type":"scattergl"}],"scattermapbox":[{"marker":{"colorbar":{"outlinewidth":0,"ticks":""}},"type":"scattermapbox"}],"scatterpolar":[{"marker":{"colorbar":{"outlinewidth":0,"ticks":""}},"type":"scatterpolar"}],"scatterpolargl":[{"marker":{"colorbar":{"outlinewidth":0,"ticks":""}},"type":"scatterpolargl"}],"scatterternary":[{"marker":{"colorbar":{"outlinewidth":0,"ticks":""}},"type":"scatterternary"}],"surface":[{"colorbar":{"outlinewidth":0,"ticks":""},"colorscale":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]],"type":"surface"}],"table":[{"cells":{"fill":{"color":"#EBF0F8"},"line":{"color":"white"}},"header":{"fill":{"color":"#C8D4E3"},"line":{"color":"white"}},"type":"table"}]},"layout":{"annotationdefaults":{"arrowcolor":"#2a3f5f","arrowhead":0,"arrowwidth":1},"autotypenumbers":"strict","coloraxis":{"colorbar":{"outlinewidth":0,"ticks":""}},"colorscale":{"diverging":[[0,"#8e0152"],[0.1,"#c51b7d"],[0.2,"#de77ae"],[0.3,"#f1b6da"],[0.4,"#fde0ef"],[0.5,"#f7f7f7"],[0.6,"#e6f5d0"],[0.7,"#b8e186"],[0.8,"#7fbc41"],[0.9,"#4d9221"],[1,"#276419"]],"sequential":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]],"sequentialminus":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]]},"colorway":["#636efa","#EF553B","#00cc96","#ab63fa","#FFA15A","#19d3f3","#FF6692","#B6E880","#FF97FF","#FECB52"],"font":{"color":"#2a3f5f"},"geo":{"bgcolor":"white","lakecolor":"white","landcolor":"#E5ECF6","showlakes":true,"showland":true,"subunitcolor":"white"},"hoverlabel":{"align":"left"},"hovermode":"closest","mapbox":{"style":"light"},"paper_bgcolor":"white","plot_bgcolor":"#E5ECF6","polar":{"angularaxis":{"gridcolor":"white","linecolor":"white","ticks":""},"bgcolor":"#E5ECF6","radialaxis":{"gridcolor":"white","linecolor":"white","ticks":""}},"scene":{"xaxis":{"backgroundcolor":"#E5ECF6","gridcolor":"white","gridwidth":2,"linecolor":"white","showbackground":true,"ticks":"","zerolinecolor":"white"},"yaxis":{"backgroundcolor":"#E5ECF6","gridcolor":"white","gridwidth":2,"linecolor":"white","showbackground":true,"ticks":"","zerolinecolor":"white"},"zaxis":{"backgroundcolor":"#E5ECF6","gridcolor":"white","gridwidth":2,"linecolor":"white","showbackground":true,"ticks":"","zerolinecolor":"white"}},"shapedefaults":{"line":{"color":"#2a3f5f"}},"ternary":{"aaxis":{"gridcolor":"white","linecolor":"white","ticks":""},"baxis":{"gridcolor":"white","linecolor":"white","ticks":""},"bgcolor":"#E5ECF6","caxis":{"gridcolor":"white","linecolor":"white","ticks":""}},"title":{"x":0.05},"xaxis":{"automargin":true,"gridcolor":"white","linecolor":"white","ticks":"","title":{"standoff":15},"zerolinecolor":"white","zerolinewidth":2},"yaxis":{"automargin":true,"gridcolor":"white","linecolor":"white","ticks":"","title":{"standoff":15},"zerolinecolor":"white","zerolinewidth":2}}},"xaxis":{"anchor":"y","domain":[0.0,1.0],"title":{"text":"Store Count"}},"yaxis":{"anchor":"x","domain":[0.0,1.0],"title":{"text":"name"}},"legend":{"title":{"text":"region"},"tracegroupgap":0},"title":{"text":"Top Fast Food Brands Presence by Region"},"margin":{"l":20,"r":20,"t":25,"b":20}},                        {"responsive": true}                    ).then(function(){

var gd = document.getElementById('f88664f9-3dd4-4eec-bb03-07c0424d96c6');
var x = new MutationObserver(function (mutations, observer) {{
        var display = window.getComputedStyle(gd).display;
        if (!display || display === 'none') {{
            console.log([gd, 'removed!']);
            Plotly.purge(gd);
            observer.disconnect();
        }}
}});

// Listen for the removal of the full notebook cells
var notebookContainer = gd.closest('#notebook-container');
if (notebookContainer) {{
    x.observe(notebookContainer, {childList: true});
}}

// Listen for the clearing of the current output cell
var outputEl = gd.closest('.output');
if (outputEl) {{
    x.observe(outputEl, {childList: true});
}}

                        })                };                });            </script>        </div>


Visualization #5: Top Fast Food Categories from Top 500 Fast Food Restaurants Word Cloud


```python
# check the data type of the columns
print("Data types:")
print(data.dtypes)
```

    Data types:
    id              object
    dateAdded       object
    dateUpdated     object
    address         object
    categories      object
    city            object
    country         object
    latitude       float64
    longitude      float64
    name            object
    postalCode      object
    province        object
    sourceURLs      object
    websites        object
    region          object
    dtype: object



```python
import matplotlib.pyplot as plt
```


```python
#use the match_name_dict to replace names in the dataset to make it cleaner
names = data['name'].values
print("size:", len(names))

# replace names with their dictionary value
for i in range(len(names)):
    if match_name_dict.get(names[i]) != None:
        names[i] = match_name_dict[names[i]]

data['names'] = names
```

    size: 10000



```python
data['categories'].value_counts()
```




    Fast Food Restaurant                                                                     3425
    Fast Food Restaurants                                                                    3406
    Fast Food                                                                                1777
    Fast Food Restaurant and Burger Joint                                                     260
    Fast food restaurants                                                                     191
    Fast Food Restaurant and Mexican Restaurant                                               132
    Fast Food Restaurant, American Restaurant, and Sandwich Place                             101
    Fast Food Restaurant, Sandwich Place, and American Restaurant                              65
    Sandwich Place and Fast Food Restaurant                                                    35
    Fast Food Restaurant and American Restaurant                                               29
    American Restaurant and Fast Food Restaurant                                               22
    Ice Cream Shop and Fast Food Restaurant                                                    19
    Mexican Restaurant and Fast Food Restaurant                                                16
    Burger Joint, Fast Food Restaurant, and American Restaurant                                16
    Fast Food Restaurant, American Restaurant, and Burger Joint                                14
    Fast Food Restaurant, Burger Joint, and Ice Cream Shop                                     14
    Fast Food Restaurant and Sandwich Place                                                    14
    Fried Chicken Joint and Fast Food Restaurant                                               14
    Burger Joint and Fast Food Restaurant                                                      13
    fast food restaurant                                                                       13
    Fast Food Restaurant and Food                                                              13
    Fast Food Restaurant, Burger Joint, and American Restaurant                                10
    Fast Food Restaurant and Ice Cream Shop                                                    10
    Taco Place and Fast Food Restaurant                                                         7
    Fast Food Restaurant, Mexican Restaurant, and Diner                                         7
    American Restaurant, Fast Food Restaurant, and Breakfast Spot                               7
    Fast Food Restaurant, Burger Joint, and Restaurant                                          7
    Restaurant, Fast Food Restaurant, and Sandwich Place                                        6
    Sandwiches / Fast Food / American                                                           5
    Fast Food Restaurant Southwest Dallas                                                       5
    Hot Dog Joint and Fast Food Restaurant                                                      5
    Sandwich Place, Fast Food Restaurant, and American Restaurant                               4
    Burger Joint, Fried Chicken Joint, and Fast Food Restaurant                                 4
    Fast Food Restaurant and Fried Chicken Joint                                                4
    Fast Food Restaurant and Taco Place                                                         4
    Chinese Restaurant and Fast Food Restaurant                                                 4
    Coffee & Tea / Breakfast / Fast Food                                                        4
    Pizza Place, Fast Food Restaurant, and Italian Restaurant                                   3
    Restaurant, Fast Food Restaurant, and Fried Chicken Joint                                   3
    Sandwiches / Wraps / Fast Food                                                              3
    American Restaurant, Fast Food Restaurant, and Sandwich Place                               3
    Fast Food Restaurant, Mexican Restaurant, and Taco Place                                    3
    American Restaurant, Fast Food Restaurant, and Burger Joint                                 3
    Fried Chicken Joint, American Restaurant, and Fast Food Restaurant                          2
    Sandwich Place, Restaurant, and Fast Food Restaurant                                        2
    Greek Restaurant and Fast Food Restaurant                                                   2
    Fast Food Restaurant East Cobb                                                              2
    Bakery, Restaurant, and Fast Food Restaurant                                                2
    Burger Joint, Fast Food Restaurant, and Ice Cream Shop                                      2
    American Restaurant, Sandwich Place, and Fast Food Restaurant                               2
    Pizza Place, Italian Restaurant, and Fast Food Restaurant                                   2
    Burger Joint, American Restaurant, and Fast Food Restaurant                                 2
    Bakery & Pastries / American / Fast Food                                                    2
    Taco Place, Mexican Restaurant, and Fast Food Restaurant                                    2
    Fast Food Restaurant, Ice Cream Shop, and Burger Joint                                      2
    Sandwich Place, Deli / Bodega, and Fast Food Restaurant                                     2
    Hamburgers / Fast Food / Burgers                                                            2
    Sandwich Place, American Restaurant, and Fast Food Restaurant                               2
    Fast Food Restaurant Boyle Heights                                                          2
    Fried Chicken Joint, Fast Food Restaurant, and Food                                         2
    Fast Food Restaurant, Mexican Restaurant, and Burrito Place                                 2
    Fast Food Restaurant Central Oklahoma City                                                  2
    Fast Food Restaurant Carr Square                                                            1
    American Restaurant, Fast Food Restaurant, and Event Space                                  1
    Fast Food Restaurant East Portland                                                          1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Fort Smith Eastside           1
    Fast Food Restaurant Canarsie                                                               1
    Fast Food Restaurant, American Restaurant, and Asian Restaurant                             1
    Sandwich Place and Fast Food Restaurant Downtown Brooklyn                                   1
    Asian Restaurant, Chinese Restaurant, and Fast Food Restaurant                              1
    Fast Food Restaurant and Mexican Restaurant Athmar Park                                     1
    Fast Food Restaurant Lookout Valley - Lookout Mountain                                      1
    Fast Food Restaurant OST - South Union                                                      1
    Fried Chicken Joint, Fast Food Restaurant, and American Restaurant                          1
    Fast Food Restaurant and Fried Chicken Joint South Congress                                 1
    Fast Food Restaurant and Burger Joint South Side                                            1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Ellet                         1
    Fast Food Restaurant and Mexican Restaurant South Boulder                                   1
    Fast Food Restaurant, American Restaurant, and Sandwich Place South Columbus                1
    Fast Food Restaurant, Sandwich Place, and American Restaurant Centennial Hills              1
    Fried Chicken Joint and Fast Food Restaurant Model City                                     1
    Asian Restaurant, Fast Food Restaurant, and Chinese Restaurant                              1
    Fast Food Restaurant and Burger Joint Northwest Columbia                                    1
    Restaurant, Fast Food Restaurant, and Sandwich Place Northwest Raleigh                      1
    Fast Food Restaurant and Burger Joint South Knoxville                                       1
    Fast Food Restaurant North Houston                                                          1
    Burgers / Breakfast / Fast Food                                                             1
    Fried Chicken Joint and Fast Food Restaurant Park View                                      1
    Fast Food Restaurant and Burger Joint Manton                                                1
    Fast Food Restaurant Willowbrook                                                            1
    Seafood / American / Fast Food                                                              1
    Fast Food Restaurant and Burger Joint Mid-City                                              1
    Fried Chicken Joint, Fast Food Restaurant, and Wings Joint                                  1
    Fast Food Restaurant and American Restaurant North Park                                     1
    Fast Food Restaurant and Mexican Restaurant Downtown Mesa                                   1
    Asian Restaurant, Fast Food Restaurant, and Chinese Restaurant Anderson Arbor               1
    Fast Food Restaurant Historic Downtown                                                      1
    Burger Joint and Fast Food Restaurant Terrell Heights                                       1
    Fast Food Restaurant and Burger Joint Old North Columbus                                    1
    Fast Food Restaurant Mid City South                                                         1
    Fast Food Restaurant Cobblestone                                                            1
    Pizza / Fast Food / American                                                                1
    Sandwich Place and Fast Food Restaurant Crossroads                                          1
    Ice Cream Shop, Burger Joint, and Fast Food Restaurant                                      1
    Fried Chicken Joint and Fast Food Restaurant West Bronx                                     1
    Fast Food Restaurant, Burrito Place, and American Restaurant                                1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Northeast Warren              1
    Sandwich Place and Fast Food Restaurant Governours Square                                   1
    Fast Food Restaurant, Burger Joint, and Breakfast Spot                                      1
    Sandwich Place and Fast Food Restaurant Upper East Side                                     1
    Fast Food Restaurant Shadowood Square                                                       1
    Fried Chicken Joint and Fast Food Restaurant Midtown                                        1
    Fast Food Restaurant and Burger Joint Dinsmore                                              1
    Chinese Restaurant and Fast Food Restaurant West Eugene                                     1
    Fast Food Restaurant, Burger Joint, and Breakfast Spot Kearny Mesa                          1
    Fast Food Restaurant and Mexican Restaurant Cascade-Fairwood                                1
    Fast Food Restaurant, American Restaurant, and Fried Chicken Joint                          1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Stone Oak                     1
    Fast Food Restaurant North San Jose                                                         1
    Fried Chicken Joint, Food, and Fast Food Restaurant Historic Mitchell Street                1
    Fast Food Restaurant, Sandwich Place, and American Restaurant Savage - Guilford             1
    Burger Joint and Fast Food Restaurant Brooklyn - Centre                                     1
    Gas Station, Convenience Store, and Fast Food Restaurant                                    1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Southeast Jacksonville        1
    Fast Food Restaurant and Burger Joint Deerwood                                              1
    Fast Food Restaurant Forest Lakes                                                           1
    Burger Joint, Fast Food Restaurant, and American Restaurant The Promenade                   1
    Burger Joint and Fast Food Restaurant Rancho San Clemente                                   1
    Fast Food Restaurant Encino                                                                 1
    Fast Food Restaurant, Diner, and American Restaurant                                        1
    Fast Food Restaurant and Burger Joint Ooltewah - Summit                                     1
    Burger Joint and Fast Food Restaurant Forest Park West                                      1
    Fast Food Restaurant Hilliard Green                                                         1
    Fried Chicken Joint, Food, and Fast Food Restaurant                                         1
    Sandwich Place, Fast Food Restaurant, and American Restaurant Amphi                         1
    Fried Chicken Joint and Fast Food Restaurant Southwest Dallas                               1
    Fast Food Restaurant and Burger Joint North Naples                                          1
    Sandwich Place, Fast Food Restaurant, and Shopping Mall                                     1
    American Restaurant, Burger Joint, and Fast Food Restaurant                                 1
    Fast Food Restaurant, American Restaurant, and Hot Dog Joint                                1
    Fast Food Restaurant, American Restaurant, and Sandwich Place North Central Pensacola       1
    Fast Food Restaurant, Convenience Store, and American Restaurant                            1
    American Restaurant and Fast Food Restaurant Broadmoor-Sherwood                             1
    Fast Food Restaurant and Burger Joint South Salem                                           1
    Burger Joint and Fast Food Restaurant Far East Detroit                                      1
    Fast Food Restaurant and Burger Joint Kenton                                                1
    Fast Food Restaurant and Burger Joint Downtown Beaverton                                    1
    Fast Food Restaurant, Hot Dog Joint, and American Restaurant                                1
    Fast Food Restaurant West Columbia                                                          1
    Fast Food Restaurant and Burger Joint Black Rock                                            1
    Fast Food Restaurant Belle Creek                                                            1
    Ice Cream Shop, Fast Food Restaurant, and Dessert Shop                                      1
    Bakeries / Desserts / Fast Food                                                             1
    Fried Chicken Joint and Fast Food Restaurant Central                                        1
    Pizza Place and Fast Food Restaurant                                                        1
    Mediterranean Restaurant, Fast Food Restaurant, and Middle Eastern Restaurant               1
    Fast Food Restaurant and Mexican Restaurant Park Glen                                       1
    Fast Food Restaurant, American Restaurant, and Sandwich Place South Orange                  1
    Fast Food Restaurant Crown Heights                                                          1
    Fast Food Restaurant and Mexican Restaurant Town Center                                     1
    Fast Food Restaurant South Kilbourne                                                        1
    Fast Food Restaurant North Philadelphia                                                     1
    Fast Food Restaurant, Mexican Restaurant, and Fried Chicken Joint Hilltop                   1
    Fast Food Restaurant and Burger Joint Allegheny West                                        1
    Fast Food Restaurant Haddington                                                             1
    Fast Food Restaurant Central Oakland                                                        1
    Fast Food Restaurant Kendall-Whittier                                                       1
    Fast Food Restaurant and Burger Joint Midtown                                               1
    Fast Food Restaurant Mid City North                                                         1
    Restaurant, Fast Food Restaurant, and Sandwich Place Crestview - Wooten                     1
    Fast Food Restaurant, American Restaurant, and Seafood Restaurant                           1
    Fast Food Restaurant, Burger Joint, and Airport Food Court                                  1
    fast food restaurants                                                                       1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Far West Side                 1
    Fried Chicken Joint and Fast Food Restaurant San Ysidro                                     1
    Fast Food Restaurant and Mexican Restaurant Northeast San Antonio                           1
    Fast Food Restaurant and American Restaurant Central Oklahoma City                          1
    Restaurant, Fried Chicken Joint, and Fast Food Restaurant                                   1
    Fast Food Restaurant Cherry Hill                                                            1
    Mexican Restaurant, Fast Food Restaurant, and Taco Place                                    1
    Fast Food Restaurant Lents                                                                  1
    American / Hamburgers / Fast Food                                                           1
    Fast Food Restaurant Cary Park                                                              1
    Fast Food Restaurant, Burger Joint, and American Restaurant West Arlington                  1
    Fast Food Restaurant and Sandwich Place Bayside                                             1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Great Neck                    1
    Fast Food Restaurant Atascocita South                                                       1
    Fast Food Restaurant and Mexican Restaurant Kendrick Lake                                   1
    Fast Food Restaurant, Sandwich Place, and American Restaurant Crestview - Wooten            1
    Pizza Place, Fried Chicken Joint, and Fast Food Restaurant                                  1
    Mexican Restaurant, Taco Place, and Fast Food Restaurant                                    1
    Sandwich Place and Fast Food Restaurant Allegheny West                                      1
    Fast Food Restaurant, Asian Restaurant, and Chinese Restaurant                              1
    Diner, Breakfast Spot, and Fast Food Restaurant                                             1
    Fast Food Restaurant and Burger Joint Irvington                                             1
    Fast Food Restaurant and Mexican Restaurant Downtown Longview                               1
    Fast Food Restaurant and Mexican Restaurant Downtown Grand Prairie                          1
    Fast Food Restaurant and Burger Joint Ukrainian Village                                     1
    Taco Place, Fast Food Restaurant, and Mexican Restaurant Valley Station                     1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Northwest Oklahoma City       1
    Fast Food Restaurant, American Restaurant, and Sandwich Place East Louisville               1
    Fast Food Restaurant, American Restaurant, and Sandwich Place North Buckhead                1
    Fried Chicken Joint and Fast Food Restaurant Elmhurst                                       1
    Fast Food Restaurant Rainier Valley                                                         1
    Fast Food Restaurant, Sandwich Place, and American Restaurant Camelback East                1
    Fast Food Restaurant, Sandwich Place, and American Restaurant Superstition Springs          1
    Fast Food / Sandwiches / Wraps                                                              1
    Fast Food Restaurant Military                                                               1
    Fast Food Restaurant Camelback East                                                         1
    Fast Food Restaurant South Mountain                                                         1
    Ice Cream Shop and Fast Food Restaurant Citrus Park Community                               1
    Fast Food Restaurant Lyell-Otis                                                             1
    Burger Joint, Fast Food Restaurant, and Playground                                          1
    Fast Food Restaurant Downtown                                                               1
    Fast Food Restaurant and American Restaurant Mexicantown - Southwest Detroit                1
    Fast Food Restaurant Mid-City                                                               1
    Fast Food Restaurant and Japanese Restaurant                                                1
    Sandwich Place, Fast Food Restaurant, and Food                                              1
    Fast Food Restaurant, Arcade, and Food                                                      1
    Fast Food Restaurant East Bay                                                               1
    American Restaurant, Fast Food Restaurant, and Sandwich Place Central Omaha                 1
    Fast Food Restaurant South End                                                              1
    Hot Dog Joint, Fast Food Restaurant, and Food                                               1
    Hot Dog Joint and Fast Food Restaurant Canyon Country                                       1
    Burger Joint and Fast Food Restaurant Central City South                                    1
    Burger Joint and Fast Food Restaurant Gulf Breeze                                           1
    Fast Food Restaurant and Playground                                                         1
    Sandwich Place, Pizza Place, and Fast Food Restaurant                                       1
    Ice Cream Shop and Fast Food Restaurant Christian Park                                      1
    Ice Cream Shop, Fast Food Restaurant, and Burger Joint                                      1
    Pizza Place, Fast Food Restaurant, and Italian Restaurant Preston Park                      1
    Fast Food Restaurant Fairpark                                                               1
    Fast Food Restaurant Heart of Missoula                                                      1
    Fast Food Restaurant and Gas Station                                                        1
    Fast Food Restaurant, Playground, and Burger Joint Northeast                                1
    Fast Food Restaurant and Burger Joint South Newport News                                    1
    Sandwich Place, Building, and Fast Food Restaurant                                          1
    Fast Food Restaurant South Vallejo                                                          1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Huffman                       1
    Fast Food Restaurant Grand Chute                                                            1
    Sandwich Place and Fast Food Restaurant Northwest Columbia                                  1
    Fast Food Restaurant Northeast Salem                                                        1
    Fast Food Restaurant Rockwood                                                               1
    Fast Food Restaurant Hayden Island                                                          1
    Fast Food Restaurant Gresham-Centennial                                                     1
    Fast Food Restaurant and Mexican Restaurant Highland                                        1
    Fast Food Restaurant, American Restaurant, and Sandwich Place East Bloomington              1
    Fast Food Restaurant Downtown Compton                                                       1
    Burger Joint, Fast Food Restaurant, and American Restaurant City Center                     1
    Fast Food Restaurant Saint Helena                                                           1
    Fast Food Restaurant Nellis Air Force Base                                                  1
    Fast Food Restaurant and Mexican Restaurant Paradise Valley                                 1
    Chinese Restaurant and Fast Food Restaurant Union Square                                    1
    Fast Food Restaurant Dallas Bay - Lakesite                                                  1
    Fast Food Restaurant and Burger Joint Amnicola - East Chattanooga                           1
    Sandwich Place, Fast Food Restaurant, and Soup Place                                        1
    Mexican / Fast Food                                                                         1
    Fast Food Restaurant, Mexican Restaurant, and Taco Place South Side                         1
    Fast Food Restaurant and Burger Joint Northeast Pensacola                                   1
    Fast Food Restaurant Barton Chapel                                                          1
    Fast Food Restaurant, Playground, and Burger Joint                                          1
    Fast Food Restaurant, American Restaurant, and Burger Joint Stonebridge Ranch               1
    Fast Food Restaurant and Seafood Restaurant                                                 1
    Fast Food Restaurant Eagledale                                                              1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Westwood Village              1
    Fast Food Restaurant, Fried Chicken Joint, and Food                                         1
    Latin American Restaurant and Fast Food Restaurant                                          1
    Fast Food Restaurant, Burger Joint, and Home (private)                                      1
    Fast Food Restaurant Downtown Boston                                                        1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Northeast Philadelphia        1
    Fast Food Restaurant and Burger Joint Highland-Stoner Hill                                  1
    Fast Food Restaurant and Burger Joint Broadmoor-Anderson Island-Shreve Isle                 1
    Fast Food Restaurant and Burger Joint Mid City North                                        1
    Taco Place, Fast Food Restaurant, and Mexican Restaurant                                    1
    Fast Food Restaurant and Burger Joint South San Jose                                        1
    Fast Food Restaurant and Taco Place Maple Lawn                                              1
    Fast Food Restaurant and Mexican Restaurant North Mountain                                  1
    American Restaurant, Fast Food Restaurant, and Breakfast Spot Polaris                       1
    American Restaurant, Fast Food Restaurant, and Breakfast Spot Bevo Mill                     1
    American Restaurant, Fast Food Restaurant, and Breakfast Spot Downtown Indianapolis         1
    Restaurant, Sandwich Place, and Fast Food Restaurant                                        1
    Restaurant, Fast Food Restaurant, and Sandwich Place Reservoir                              1
    Middle Eastern Restaurant and Fast Food Restaurant                                          1
    Fast Food Restaurant and Burger Joint Downtown Renton                                       1
    Fast Food Restaurant Saint Charles                                                          1
    Ice Cream Shop and Fast Food Restaurant Greater East Side                                   1
    Fast Food Restaurant and Sandwich Place Northeast San Antonio                               1
    Fast Food Restaurant and Sandwich Place Yale Park                                           1
    Fast Food Restaurant and Burger Joint Austin                                                1
    Fast Food Restaurant and Mexican Restaurant Centennial Hills                                1
    Burger Joint and Fast Food Restaurant Downtown Tempe                                        1
    Fast Food Restaurant English Avenue                                                         1
    Sandwich Place and Fast Food Restaurant Ohio City                                           1
    American Restaurant, Fast Food Restaurant, and Breakfast Spot Far Eastside                  1
    BBQ Joint and Fast Food Restaurant                                                          1
    Sushi Restaurant and Fast Food Restaurant                                                   1
    Fast Food Restaurant and Burger Joint Downtown Des Moines                                   1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Village of Tampa              1
    Fast Food Restaurant Highlands                                                              1
    Fast Food Restaurant Southeast Yonkers                                                      1
    Fast Food Restaurant, Gas Station, and Burger Joint                                         1
    Mexican Restaurant, Fast Food Restaurant, and Diner                                         1
    Deli / Bodega, Fast Food Restaurant, and American Restaurant                                1
    Fast Food Restaurant Uptown                                                                 1
    Fast Food Restaurant, American Restaurant, and Sandwich Place East Akron                    1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Wallhaven                     1
    Burgers / American / Fast Food                                                              1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Southwest Arlington           1
    Fast Food Restaurant Central San Diego                                                      1
    Fast Food Restaurant Hickory Valley - Hamilton Place                                        1
    Mexican Restaurant and Fast Food Restaurant Northwest Torrance                              1
    Burger Joint, Fried Chicken Joint, and Fast Food Restaurant Cabrillo                        1
    Sandwich Place and Fast Food Restaurant Belltown                                            1
    Fast Food Restaurant, American Restaurant, and Sandwich Place Northwest Columbia            1
    Fast Food Restaurant, American Restaurant, and Ice Cream Shop                               1
    Fish Chips Shop and Fast Food Restaurant                                                    1
    Fast Food Restaurant and Burger Joint Linden                                                1
    Fast Food Restaurant and Burger Joint St. Elizabeth's                                       1
    Fast Food Restaurant North Sacramento                                                       1
    Fast Food Restaurant Linda Vista                                                            1
    Fast Food Restaurant Northwest Columbus                                                     1
    Fast Food Restaurant North Overton                                                          1
    Fast Food Restaurant and Burger Joint Greater Third Ward                                    1
    Burger Joint and Fast Food Restaurant Floresta                                              1
    Name: categories, dtype: int64




```python
# split the categories string data by ","
categories = data['categories'].values
for i in range(len(categories)):
    categories[i] = categories[i].split(",")
```


```python
# update the "categories" column in the fastfood_data
data['categories'] = categories
data.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>dateAdded</th>
      <th>dateUpdated</th>
      <th>address</th>
      <th>categories</th>
      <th>city</th>
      <th>country</th>
      <th>latitude</th>
      <th>longitude</th>
      <th>name</th>
      <th>postalCode</th>
      <th>province</th>
      <th>sourceURLs</th>
      <th>websites</th>
      <th>region</th>
      <th>names</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>AVwcmSyZIN2L1WUfmxyw</td>
      <td>2015-10-19T23:47:58Z</td>
      <td>2018-06-26T03:00:14Z</td>
      <td>800 N Canal Blvd</td>
      <td>[American Restaurant and Fast Food Restaurant]</td>
      <td>Thibodaux</td>
      <td>US</td>
      <td>29.814697</td>
      <td>-90.814742</td>
      <td>sonicdrivein</td>
      <td>70301</td>
      <td>LA</td>
      <td>https://foursquare.com/v/sonic-drive-in/4b7361...</td>
      <td>https://locations.sonicdrivein.com/la/thibodau...</td>
      <td>South</td>
      <td>sonicdrivein</td>
    </tr>
    <tr>
      <th>1</th>
      <td>AVwcmSyZIN2L1WUfmxyw</td>
      <td>2015-10-19T23:47:58Z</td>
      <td>2018-06-26T03:00:14Z</td>
      <td>800 N Canal Blvd</td>
      <td>[Fast Food Restaurants]</td>
      <td>Thibodaux</td>
      <td>US</td>
      <td>29.814697</td>
      <td>-90.814742</td>
      <td>sonicdrivein</td>
      <td>70301</td>
      <td>LA</td>
      <td>https://foursquare.com/v/sonic-drive-in/4b7361...</td>
      <td>https://locations.sonicdrivein.com/la/thibodau...</td>
      <td>South</td>
      <td>sonicdrivein</td>
    </tr>
    <tr>
      <th>2</th>
      <td>AVwcopQoByjofQCxgfVa</td>
      <td>2016-03-29T05:06:36Z</td>
      <td>2018-06-26T02:59:52Z</td>
      <td>206 Wears Valley Rd</td>
      <td>[Fast Food Restaurant]</td>
      <td>Pigeon Forge</td>
      <td>US</td>
      <td>35.803788</td>
      <td>-83.580553</td>
      <td>tacobell</td>
      <td>37863</td>
      <td>TN</td>
      <td>https://www.yellowpages.com/pigeon-forge-tn/mi...</td>
      <td>http://www.tacobell.com,https://locations.taco...</td>
      <td>South</td>
      <td>tacobell</td>
    </tr>
    <tr>
      <th>3</th>
      <td>AVweXN5RByjofQCxxilK</td>
      <td>2017-01-03T07:46:11Z</td>
      <td>2018-06-26T02:59:51Z</td>
      <td>3652 Parkway</td>
      <td>[Fast Food]</td>
      <td>Pigeon Forge</td>
      <td>US</td>
      <td>35.782339</td>
      <td>-83.551408</td>
      <td>arbys</td>
      <td>37863</td>
      <td>TN</td>
      <td>http://www.yellowbook.com/profile/arbys_163389...</td>
      <td>http://www.arbys.com,https://locations.arbys.c...</td>
      <td>South</td>
      <td>arbys</td>
    </tr>
    <tr>
      <th>4</th>
      <td>AWQ6MUvo3-Khe5l_j3SG</td>
      <td>2018-06-26T02:59:43Z</td>
      <td>2018-06-26T02:59:43Z</td>
      <td>2118 Mt Zion Parkway</td>
      <td>[Fast Food Restaurant]</td>
      <td>Morrow</td>
      <td>US</td>
      <td>33.562738</td>
      <td>-84.321143</td>
      <td>steaknshake</td>
      <td>30260</td>
      <td>GA</td>
      <td>https://foursquare.com/v/steak-n-shake/4bcf77a...</td>
      <td>http://www.steaknshake.com/locations/23851-ste...</td>
      <td>South</td>
      <td>steaknshake</td>
    </tr>
  </tbody>
</table>
</div>




```python
# top 500 most appeared restaurants in the dataset and their corresponding category
top500_name_by_number = data['name'].value_counts()[:500].index.tolist()
top500_rest_categories = []
for name in top500_name_by_number:
    category = data[data.name == name]["categories"][:1].values[0]
    top500_rest_categories.append(category)
```


```python
# remove stopword "Restaurants", "Restaurant", and "Fast Food Restaurants" in categories
stopwords = ["Fast Food Restaurants","Fast Food restaurants", "Fast Food", "Restaurants", "Restaurant", "restaurants", "restaurant"]
for i in range(len(top500_rest_categories)):
    for j in range(len(top500_rest_categories[i])):
        word = top500_rest_categories[i][j]
        # remove stopword as the only word given
        for stopword in stopwords:
            isRemoved = False
            if isRemoved == False and word == stopword:
                top500_rest_categories[i][j] = top500_rest_categories[i][j].replace(stopword, "")
                isRemoved = True

        # replace the stopword within a group of words
        for stopword in stopwords:
            if isRemoved == False and stopword in word:
                top500_rest_categories[i][j] = top50_rest_categories[i][j].replace(stopword, "")
```


```python
top500_rest_categories
```




    [[''],
     [' '],
     [' '],
     [' '],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [' '],
     [''],
     ['American  and  '],
     [' '],
     [' '],
     [' '],
     [''],
     [' '],
     [''],
     [''],
     ['Burger Joint and   Gulf Breeze'],
     [' ', ' Mexican ', ' and Taco Place'],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [''],
     ['Diner', ' Breakfast Spot', ' and  '],
     [''],
     [' '],
     [' '],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [''],
     ['Mexican  and  '],
     [''],
     [' '],
     [' '],
     [''],
     [' '],
     [''],
     ['Pizza Place', '  ', ' and Italian  Preston Park'],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [''],
     ['American  and  '],
     [''],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [' '],
     [''],
     [' '],
     [' '],
     [' '],
     [' '],
     [' '],
     [''],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [''],
     ['Latin American  and  '],
     [' '],
     [''],
     [''],
     [''],
     ['Fried Chicken Joint and   Elmhurst'],
     [' '],
     [''],
     [''],
     ['Coffee & Tea / Breakfast / '],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [' '],
     [' '],
     [' '],
     [' '],
     [''],
     [''],
     [''],
     ['fast food '],
     ['American ', '  ', ' and Sandwich Place Central Omaha'],
     [''],
     [''],
     [' '],
     [' ', ' American ', ' and Burger Joint'],
     [''],
     ['Ice Cream Shop', '  ', ' and Burger Joint'],
     ['Sandwich Place', ' Pizza Place', ' and  '],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [' '],
     [' '],
     [''],
     [' '],
     [''],
     ['  and American '],
     [' '],
     [''],
     [' '],
     ['  and Japanese '],
     [''],
     [' '],
     [''],
     [''],
     [' '],
     [''],
     [' '],
     [' '],
     [''],
     ['American  and  '],
     [' '],
     [''],
     [''],
     ['  and Mexican '],
     [''],
     ['Burger Joint', '  ', ' and American '],
     ['Fried Chicken Joint', '  ', ' and Wings Joint'],
     [''],
     ['American  and  '],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [' '],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [''],
     ['Bakery & Pastries / American / '],
     [''],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [' '],
     [' ', ' American ', ' and Fried Chicken Joint'],
     [''],
     [''],
     [''],
     [''],
     ['  Crown Heights'],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [' ', ' American ', ' and Seafood '],
     [''],
     [''],
     [''],
     ['Sandwich Place and  '],
     [''],
     [''],
     [' '],
     [''],
     [' '],
     [''],
     [''],
     [' '],
     [' '],
     [''],
     [''],
     [''],
     ['Burger Joint', '  ', ' and American '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [' '],
     [' '],
     [' '],
     [' '],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [' '],
     [''],
     [''],
     [''],
     [' '],
     ['Greek  and  '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [''],
     ['American  and  '],
     [''],
     [''],
     [''],
     [''],
     ['Mexican  and  '],
     [' '],
     [''],
     [''],
     ['Mexican  and  '],
     [''],
     [' '],
     [''],
     [''],
     [''],
     ['  and Mexican '],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [' '],
     [''],
     [''],
     [''],
     [' '],
     [''],
     [' '],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [''],
     ['Pizza Place', '  ', ' and Italian '],
     [' '],
     ['Fried Chicken Joint', ' American ', ' and  '],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [' '],
     [''],
     [''],
     ['Hot Dog Joint and  '],
     [' '],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [' '],
     [''],
     [''],
     [''],
     ['Chinese  and  '],
     [''],
     [''],
     [''],
     [' '],
     [' '],
     ['American  and  '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [''],
     [' '],
     [' '],
     [''],
     ['BBQ Joint and  '],
     [''],
     [' '],
     [''],
     [''],
     [' '],
     [''],
     [' '],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [''],
     ['Sushi  and  '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     ['Pizza Place', ' Fried Chicken Joint', ' and  '],
     [''],
     ['Burger Joint and  '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' ', ' American ', ' and Burger Joint'],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     ['Fried Chicken Joint', '  ', ' and Food'],
     [''],
     [''],
     [''],
     ['Sandwich Place and   Allegheny West'],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [' '],
     [''],
     [''],
     [''],
     [' '],
     [' '],
     [''],
     [''],
     [' '],
     ['  and American  North Park'],
     [''],
     [''],
     [' '],
     [''],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [' '],
     [''],
     [' '],
     [''],
     [''],
     [' '],
     [''],
     [' '],
     [' '],
     [''],
     [''],
     [''],
     [' '],
     [' '],
     [' '],
     [' '],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [''],
     [' '],
     [''],
     [''],
     [''],
     ['']]




```python
from wordcloud import WordCloud

# empty string is declare 
text = "" 

# iterating through list of rows 
for row in top500_rest_categories : 
    # iterating through words in the row 
    for word in row:
        if len(word) == 0:
            continue
        # concatenate the words 
        if word[-1] == " ":
            word = word[:-1] # remove the last space character
        text = text + " " + word.replace(" ", "_") 
print("Vocabulary of our processed categories data:\n")
print(text)
```

    Vocabulary of our processed categories data:
    
          American__and_     Burger_Joint_and___Gulf_Breeze  _Mexican _and_Taco_Place   Diner _Breakfast_Spot _and_    Mexican__and_    Pizza_Place _ _and_Italian__Preston_Park    American__and_         Latin_American__and_  Fried_Chicken_Joint_and___Elmhurst  Coffee_&_Tea_/_Breakfast_/         fast_food American _ _and_Sandwich_Place_Central_Omaha   _American _and_Burger_Joint Ice_Cream_Shop _ _and_Burger_Joint Sandwich_Place _Pizza_Place _and_     __and_American   __and_Japanese     American__and_  __and_Mexican Burger_Joint _ _and_American Fried_Chicken_Joint _ _and_Wings_Joint American__and_    Bakery_&_Pastries_/_American_/     _American _and_Fried_Chicken_Joint __Crown_Heights    _American _and_Seafood Sandwich_Place_and_     Burger_Joint _ _and_American          Greek__and_   American__and_ Mexican__and_  Mexican__and_  __and_Mexican       Pizza_Place _ _and_Italian  Fried_Chicken_Joint _American _and_    Hot_Dog_Joint_and_     Chinese__and_   American__and_        BBQ_Joint_and_      Sushi__and_   Pizza_Place _Fried_Chicken_Joint _and_ Burger_Joint_and_  _American _and_Burger_Joint Fried_Chicken_Joint _ _and_Food Sandwich_Place_and___Allegheny_West       __and_American__North_Park             



```python
import os
from wordcloud import WordCloud
import matplotlib.pyplot as plt

desktop_path = os.path.join(os.path.expanduser("~"), "Desktop")
font_path = os.path.join(desktop_path, "RobotoSlab-VariableFont_wght.ttf")

if os.path.isfile(font_path):
    print("Font file found.")
else:
    print("Font file not found.")
```

    Font file found.



```python
wordcloud = WordCloud(width=800, height=800, background_color='white',
                      min_font_size=10, font_path=font_path).generate(text)

plt.figure(figsize=(16, 16), facecolor=None)
plt.imshow(wordcloud)
plt.axis("off")
plt.show()
```

From above wordcloud visualization, we can notice that most of the top 500 mentioned fast food restaurants has the categories of "take out", "American", and "Hamburger and Hot Dogs", which are the most unhealthy category. 
