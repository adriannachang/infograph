// Data was taken from: http://open.canada.ca/data/en/dataset/8c81f820-3116-46ed-8286-4d10f028c92b
// "Physical activity during leisure time, by sex, provinces and territories"
// Press 'f' to show only female data, 'm' to show only male data and SPACE to show all
//Press anywhere in row to see line graph data for that province/territory
//The further to the right the ellipses are, the more individuals who reported being physically
//active in that province/territory

class paData
{
  String provinceName; //Also applies to territories
  int[] yearsFemale;
  int[] yearsMale;
}

//Create array of paData; stores data for each province/territory

paData[] provinceData;

final String filename = "physical-activity-data.csv";

int totalPeopleProvince;
final int numRows = 13;
int numProvinces;
float rectHeight;

int graphShowingIndex;

boolean maleOnly = false;
boolean femaleOnly = false;
boolean showAll = true;

void setup()
{
  size(1000, 1000);
  
  readData();
  graphShowingIndex = -1;
  
} //<>//

void draw()
{
  background(255);
  
  drawData();
  
  if (graphShowingIndex >= 0)
  {
    drawLineGraph(graphShowingIndex);
  }
}


void readData()
{
  String[] lines = loadStrings(filename);
  
  //Find out how many objects need to be stored in provinceData array  
  int numDataElements = lines.length - 9;
  
  provinceData = new paData[numDataElements/3]; //Each province has three lines of data - total, male and female
  numProvinces = numDataElements/3;
  
  int lineIndex = 0;
  int provinceNum = 0;
  while (lineIndex < lines.length) //<>//
  {
    if (lineIndex < 8 || lineIndex >= lines.length - 1)
    {
      lineIndex ++;
      continue;
    } 
    
    provinceData[provinceNum] = new paData();
    provinceData[provinceNum].yearsMale = new int[5];
    provinceData[provinceNum].yearsFemale = new int[5]; //<>//
    
    int counter = 0;
    while (counter < 3)
    {
      String[] splitLine = lines[lineIndex].split(",");
      
      if ((lineIndex-2) % 3 == 0) //If on the first line for the province data (ie the line with the totals), only read in the name
      {
        provinceData[provinceNum].provinceName = splitLine[0];
      }
    
      //If on second line, read in male data
      else if (lineIndex % 3 == 0)
      {
        provinceData[provinceNum].yearsMale[0] = Integer.parseInt(splitLine[1]);
        provinceData[provinceNum].yearsMale[1] = Integer.parseInt(splitLine[2]);
        provinceData[provinceNum].yearsMale[2] = Integer.parseInt(splitLine[3]);    
        provinceData[provinceNum].yearsMale[3] = Integer.parseInt(splitLine[4]);     
        provinceData[provinceNum].yearsMale[4] = Integer.parseInt(splitLine[5]); 
      }
    
      else //If on the third line of data, read in female data
      {
        provinceData[provinceNum].yearsFemale[0] = Integer.parseInt(splitLine[1]);
        provinceData[provinceNum].yearsFemale[1] = Integer.parseInt(splitLine[2]);
        provinceData[provinceNum].yearsFemale[2] = Integer.parseInt(splitLine[3]);    
        provinceData[provinceNum].yearsFemale[3] = Integer.parseInt(splitLine[4]);   
        provinceData[provinceNum].yearsFemale[4] = Integer.parseInt(splitLine[5]);  
      }  
      counter ++;
      lineIndex ++;
    }
      provinceNum ++;
    
  }
  
}

int findMax(int n)
{
  int provinceNum = 0;
  int max = -1;
  while (provinceNum < n)
  {
    if (max < provinceData[provinceNum].yearsMale[4])
    {
       max = provinceData[provinceNum].yearsMale[4];
    }

     if (max < provinceData[provinceNum].yearsFemale[4])
     {
       max = provinceData[provinceNum].yearsFemale[4];
     }
    provinceNum ++;
  } 
  
  return max;
}

void drawData()
{
  rectMode(CORNER);
  stroke(0);
  final int max = findMax(numProvinces);
  
  final float rectWidth = (float) width-1;
  rectHeight = (float)height/numProvinces;
  final int ellipseWidth = 20;
  final int ellipseHeight = 50;
  for (int i=0; i<numProvinces; i++)
  {
    fill(255);
    rect(0, rectHeight*i, rectWidth, rectHeight);
    fill(0);
    textSize(10);
    textAlign(LEFT);
    text(provinceData[i].provinceName, 10, rectHeight* i + rectHeight*11/12);
    float xPosFemale = (float)provinceData[i].yearsFemale[4]/ max * (width-ellipseWidth*4);
    float xPosMale = (float)  provinceData[i].yearsMale[4]/ max * (width - ellipseWidth*4);
    if (femaleOnly || showAll)
    {
      fill(216, 128, 160, 100);
      ellipse(xPosFemale + ellipseWidth*3, rectHeight*i + rectHeight/2, ellipseWidth, ellipseHeight);
    }
    if (maleOnly || showAll)
    {
      fill(25, 137, 216, 80);
      ellipse(xPosMale + ellipseWidth*3, rectHeight*i + rectHeight/2, ellipseWidth, ellipseHeight);
    }
  }
  
}

void drawLineGraph(int index)
{
  rectMode(CENTER);
  final int padding = 40;
  
  final int rWidth = (int)(width * 0.8f);
  final int rHeight = (int)(height * 0.6f);
  
  final int axisX = width/2 - rWidth/2 + padding;
  final int axisY = height/2 + rHeight/2 - padding;
  final int axisHeight = rHeight - 2 * padding;
  
  int numPoints = 5; 
  int maxValue = max(provinceData[index].yearsMale);
  
  // Draw a rectangle to contain the graph
  stroke(2);
  fill(255);
  rect(width/2, height/2, rWidth, rHeight);

  // Label the province
  fill(0);
  textSize(18);
  textAlign(CENTER, CENTER);
  text(provinceData[index].provinceName, width/2, height/2 + rHeight/2 - padding/2); 

  // Draw axes
  line(axisX, axisY, axisX, height-axisY);
  line(axisX, axisY, width-axisX, axisY);
  
  // Figure out how much space to put between the points
  // on the graph
  int spacing = (rWidth - 2*axisX)/numPoints;
  
  // Draw the line graph (male)
  stroke(0,0,255);
  
  
  // Now that we have a single array we can loop over to get
  // the data points, it's a lot easier to make the line graph
  
  float lastPointX = axisX;
  float lastPointY = axisY;
  
  int pointNum = 0;
  while (pointNum < numPoints)
  {
    float yValue = provinceData[index].yearsMale[pointNum];
    yValue = yValue / maxValue * axisHeight;
    yValue = axisY - yValue;
    
    line(lastPointX, lastPointY, lastPointX+spacing, yValue);
    lastPointX = lastPointX+spacing;
    lastPointY = yValue;
    pointNum++;
  }
  
  pointNum = 0;
  lastPointX = axisX;
  lastPointY = axisY;
  
  //Draw line graph (female)
  stroke(216,128,160);
   while (pointNum < numPoints)
  {
    float yValue = provinceData[index].yearsFemale[pointNum];
    yValue = yValue / maxValue * axisHeight;
    yValue = axisY - yValue;
    
    line(lastPointX, lastPointY, lastPointX+spacing, yValue);
    lastPointX = lastPointX+spacing;
    lastPointY = yValue;
    pointNum++;
  }
}


void keyPressed()
{
  if (key == 'm')
  {
    maleOnly = true;
    showAll = false;
    femaleOnly = false;
  }
  
  else if (key == 'f')
  {
    femaleOnly = true;
    maleOnly = false;
    showAll = false;
  }
  else if (key == ' ')
  {
    showAll = true;
    maleOnly = false;
    femaleOnly = false;
  }
}

void mouseClicked()
{
  // Turn off the graph if it was on
  if (graphShowingIndex >= 0)
  {
    graphShowingIndex = -1;
  }
  // Otherwise, figure out what index we clicked
  else
  {
    
    for (int i=0; i<numProvinces; i++)
    {
      if (mouseY > i*rectHeight && mouseY < (i+1)*rectHeight)
      {
        graphShowingIndex = i;
      }
    }
  }
}