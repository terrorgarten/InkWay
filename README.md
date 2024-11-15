### Readme needs update, this is the old version from first iteration of this project.

# Aplikace InkWay
InkWay je jednoduchá aplikace pro vyhledávání tatérů po světě, momentálně 
v první demoverzi. Byla vytvořena jako projekt do předmětu IZA na FIT VUT 
v Brně pod výukou pana doktora Martina Hrubého.

### Demo video: https://youtu.be/TnKh-cFeBxo

## Stručný popis aplikace
InkWay je určená k rychlému a nenáročnému vyhledávání kontaktů na tatéry 
ve Vašem okolí kdekoliv budete. Jako uživatel můžete pouze procházet, 
kontaktovat je již musíte individuálně, zvolil jsem jako kontakt instagram 
handle, protože mám osobně pocit, že to je pro tatéry největší konverzní 
místo. Pokud se přepnete do pohledu umělce, respektive tatéra, tak máte 
možnost nahrávat vlastní designy, označit si na mapě svoji lokaci a 
prezentovat se tak například turistům, kteří by si rádi dovezli z dovolené 
tetování. Uživatel však uvidí pouze město, což by mohl být krok vyšší 
online bezpečnosti. Případně by se dalo velice snadno dodělat rozcestí 
např. přes webové stránky ale to nebylo účelem tohoto projektu. Zde jde 
spíše o demonstraci práce se SwiftUI.

## Technologický stack
- MVVM Architektura - obvyklá pro tento typ projektů
- SwiftUI - frontend - požadavek na projekt. Vybral jsem SwiftUI oproti 
UIKitu hlavně kvůli přehlednosti
- Firebase - backend- nejsnazší cesta. Firebase na free tieru poskytuje 
jak storage pro ukládání designů tatérů, tak noSQL databázi a dokonce i 
zabudovaný autentizační systém, což mi přišlo super a chtěl jsem si to 
vyzkoušet. Zhodnotil bych to jako velice dobré rozhodnutí pro tento školní 
projekt, výrazně mi to ulehčilo práci na backendu.  U velkého projektu 
bych ale váhal kvůli poplatkům, výhodou ale je zase stabilita, těžko říct, 
co vybrat.
- Verzování - Git/GitHub, klasika. 
- Editor - XCode, překvapivě příjemné prostředí, ale upřímně mi to přišlo 
hodně pomalé. V porovnání s VS/C#/.NET ale velmi srovnatelné.
- Detaily:
	- Správa lokací: CoreLocation.
	- Mapy: MapKit a externí komponenty - např. vybíraní lokace z mapy 
je otevřená komponenta z githubu.
	- Připojení backendu - Přímá integrace do balíků Firebase.

## Technické poznatky
Aplikace je velmi jednoduchá, všechno řídí MainView který provolává 
ostatní views a řídí typ pohledu, tedy user nebo artist. Vybírání lokací a 
geografické výpočty se řeší přes CoreLocation, mapy přes externí 
komponenty, které stačí zavolat jako view. Nahrávání fotek je řešené přes 
UIKit, protože jsem nenašel jiný způsob a i tak to bylo trochu nepříjemné. 

## Závěr
Apliakce je poskytována pod veřejnou licencí GPL 3.0. 
Není nasazená do provozu kvůli backendu - možná se k ní přes prázdniny 
ještě dostanu a dodělám ji.



