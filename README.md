<h1 align="center">Welcome to pitu_multiJob 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.2.5-blue.svg?cacheSeconds=2592000" />
  <a href="https://github.com/Pitu7944/pitu_multiJob#readme" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
  <a href="https://github.com/Pitu7944/pitu_multiJob/graphs/commit-activity" target="_blank">
    <img alt="Maintenance" src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" />
  </a>
</p>

> FiveM esx addon for adding second job, gang/mafia/etc...

### 🏠 [Homepage](https://github.com/Pitu7944/pitu_multiJob#readme)
## Installation
<b>Dependencies</b>
```
mysql-async
es_extended
essentialsmode
esx_property
esx_addoninventory
esx_clotheshop
```
<b>Setting up your Database</b>
```
import the provided pitu_multijob.sql to your Database
```

## Usage
<b>Setting a Job:</b>
```
/pmj_setjob {id} {job} {grade}
```

<b>Removing a Job:</b>
```
/pmj_unsetjob {id}
```

<b>Checking a Job:</b>
```
/pmj_checkjob {id}
```

<b>Getting info about own Job:</b>
```
/pmjinfo
```

<b>Adding Jobs:</b>
Just add the following code to the Config.jobs, the script will take care of the rest
```lua
{
    name = 'example', -- name of the job (to set job a player do /pmj_setjob {id} {name} {grade}
    blips = { -- job blips to be displayed (https://docs.fivem.net/docs/game-references/blips/)
        {
            color = 5, -- blip color
            id = 442, -- blip sprite
            pos = {x = -1174.64,  y = -1153.64,  z = 5.64}, -- blip position
            label = 'Example - Base' -- blip Text
        }
    },
    grades = { -- job grades
        { grade = 1, label = 'Pachołek'},
        { grade = 2, label = 'Członek'},
        { grade = 3, label = 'Zaufany'},
        { grade = 4, label = 'Prawa ręka'},
        { grade = 5, label = 'Szef'},
    },
    zones = {
        boss = { -- boss menu
            rq_grade = 5,
            label = 'Naciśnij ~g~[E]~w~ aby otworzyć Menu Szefa', -- zone action message
            pos = {x = 1007.88,  y = -3170.32,  z = -39.72} -- zone position ( remember to subtract one from Z coord! )
        },
        changerooms = { -- clothing change menu
            label = 'Naciśnij ~g~[E]~w~ aby otworzyć Przebieralnie', -- zone action message
            pos = {x = 1010.6,  y = -3167.68,  z = -39.72} -- zone position ( remember to subtract one from Z coord! )
        },
        armory = { -- weapon shop menu
            label = 'Naciśnij ~g~[E]~w~ aby otworzyć Zbrojownie', -- zone action message
            pos = {x = 1001.72,  y = -3177.12,  z = -39.72}, -- zone position ( remember to subtract one from Z coord! )
            weapons = { -- add weapons here
                {weaponName = 'pistol', label = 'pistol', price = 150}, -- weaponName is weapon spawnname , label is Label
                {weaponName = 'sns_pistol', label = 'pistol', price = 100} -- weaponName is weapon spawnname , label is Label
            }
        },
        storage = { -- item storage menu
            label = 'Naciśnij ~g~[E]~w~ aby otworzyć Magazyn', -- zone action message
            pos = {x = 997.88,  y = -3172.72,  z = -39.72}, -- zone position ( remember to subtract one from Z coord! )
        },
        garage = {
            label = 'Naciśnij ~g~[E]~w~ aby otworzyć Garaż', -- zone action message
            pos = {x = 1009.32,  y = -3156.2,  z = -39.72}, -- zone position ( remember to subtract one from Z coord! )
            vehicles = { -- add vehicles here
                {spawnName = 'zentorno', label = 'Zentorno'} -- vehicle name and label
            },
            spawner = {
                x = 1005.16,  y = -3159.64,  -39.72, h = 171.72 -- zone position ( remember to NOT subtract one from Z coord! )
            },
        },
        deleter = {
            label = 'Naciśnij ~g~[E]~w~ aby schować pojazd', -- zone action message
            pos = {x = 1005.16,  y = -3159.64,  z = -39.72}, -- zone position ( remember to subtract one from Z coord! )
        }
    }
},
```

## Author

👤 **Pitu7944#2711**

* Github: [@Pitu7944\#2711](https://github.com/Pitu7944\#2711)

## Show your support

Give a ⭐️ if this project helped you!

***
