const inquirer = require ("inquirer");
const {exec} = require ("child_process");
const fs = require ("fs");
const path = require("path");
const ora = require("ora");
const sites = require("./config.json");
const date = new Date();

const root = path.join(__dirname + "/");
const rawBrands = sites.products;
const allBrands = [];
const allSites= []; 

rawBrands.forEach(site => {
    if(!allBrands.includes(site.title)){
        allBrands.push(site.title);
    }
})

//first question
inquirer
.prompt([
    {
        type: "list",
        name: "Brand",
        message: "Please select a brand:",
        choices: allBrands,
    },
])
.then(answers => {
    let brand = answers.Brand;
    console.log(`Your choice: ${brand}`);
    rawBrands.forEach((site, index) => {
        if (site.title === brand) {
            allSites.push(`${brand} <--> ${site.subtitle} <--> ${site.status} <--> ${site.url.slice(0, -1)} <--> ${index} <--> ${site.date}`);
        }; 
    });
    //second question
    inquirer
    .prompt([
        {
        type: "list",
        name: "Site",
        message: "Please select a site:",
        choices: allSites,
        } 
    ])
    .then(answers => {
        let site = answers.Site.split(" <--> ");
        console.log(`--SITE TO BE SCRAPED--\nID: ${site[4]}\nBRAND: ${site[0]}\nSITE: ${site[1]}\nSTATUS: ${site[2]}\nURL: ${site[3]}`);
        
        //updating screenshot map
        console.log("Updating screenshot map...");
        var ssmFolder = "./screenshotmap";
        let ssmOriginFile = site[3].replace("/", ".") + ".csv";
        let ssmDestFile = "./screenshotmap.csv";

        if (fs.existsSync(`${ssmFolder}/${ssmOriginFile}`)) {
            if (fs.existsSync(ssmDestFile)) {
                fs.unlinkSync(ssmDestFile);
            };
            fs.copyFileSync(`${ssmFolder}/${ssmOriginFile}`, ssmDestFile);
        }
        else {
            console.log("Screenshot map doesn't exist. Please create it and try again.");
            return null;
        }

        //creating directory structure
        let brandDir = `_sites/${brand}`;
        let siteDir = `${brandDir}/${site[3].split("/")[0]}`;
        //console.log(`siteDir = ${siteDir}`);
        console.log("Setting up brand directory...");
        if (!fs.existsSync(brandDir)) {
            fs.mkdirSync(brandDir);
        };

        if (fs.existsSync(siteDir)) {
            console.log("Removing current content...");
            fs.rmdirSync(siteDir, {recursive: true});
        };

        //creating shell script to replace scripts in files
        fs.writeFileSync("./replace.sh", `find ${root}${brandDir} -name '*.html' -exec sed -i '' -e 's|<input*.*__RequestVerificationToken*.*>||g' -e 's|<script*.*adobetrackingdb*.*/script>||g' -e 's|<script*.*assets\.adobe*.*/script>||g' -e 's|<script*.*window\.NREUM*.*/script>||g' -e 's|<script*.*_satellite*.*/script>||g' -e 's|   ||g' {} \\;`)

        //updatind date
        console.log("Updating date...");
        sites.products[site[4]]["date"] = date.toString();
        fs.writeFileSync("./config.json", JSON.stringify(sites, null, "\t"));

        //scrapping site
        const spinner = ora(`Scraping: ${site[3]}...`).start();
        exec(`/usr/local/bin/wget -e robots=off --user-agent=\"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3\" --mirror --convert-links --adjust-extension --page-requisites --reject=\"pdf,mp4\" --no-parent ${site[3]} -P ${brandDir} > /dev/null 2>&1`, function(){
            console.log("cleaning files");
            exec("bash replace.sh", function() {
                spinner.stop();
                console.log("Site scrapped!!!");
            });
        })
        });
    });