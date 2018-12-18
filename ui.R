

library(shiny)
library(shinydashboard)

ui <- dashboardPage(

  skin='green',

  dashboardHeader(title = "MARSHAL"),


  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      tags$style(".skin-blue .sidebar .shiny-download-link { color: #444; margin-left: 1em; margin-bottom: 1em;}"),
      tags$style("h4 { margin-left: 1em; margin-bottom: 1em;}"),

      menuItem("Model", tabName = "results", icon = icon("leaf")),

      menuItem("Tutorial", tabName = "tutorial", icon = icon("flask")),

      menuItem("About", tabName = "about", icon = icon("question-circle")),

      tags$hr(),
      materialSwitch("simpleroot", "Use simplified root system", status = "primary", right = TRUE, value = F),

      actionButton(inputId = "loadRoot", label="Run model", icon("cogs"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),

      tags$hr(),

      actionButton(inputId='ab13', label="Report a bug", icon = icon("bug"), onclick ="window.open('https://github.com/MARSHAL-ROOT/marshal_shiny/issues', '_blank')", style="color: #fff; background-color: #d83429; border-color: #d83429")


    )

  ),




  dashboardBody(

    tabItems(
      # Water tab content
      tabItem(tabName = "results",
              fluidRow(
                column(width = 4,
                       tabBox(
                         # Title can include an icon
                         title = tagList(shiny::icon("gear"), ""), width = NULL,
                         tabPanel("Architecture",

                         # h4("Update root parameters"),
                         selectInput("roottype", label = "Select root type", choices = c("Please load datafile")), # updated with the datafile
                         selectInput("parameter", label = "Select parameter to change", choices = c("Please load datafile")), # updated with the datafile
                         sliderInput("value", "Parameter mean:", min=10, max=20, value=10),
                         sliderInput("stdev", "Parameter deviation [%]:", min=0, max=50, value=0, step=5),
                         strong(htmlOutput("paramTitle")),
                         htmlOutput("paramText"),

                         tags$hr(),

                         # h4("Update plant parameters"),
                         selectInput("parameter2", label = "Select plant parameter to change", choices = c("Please load datafile")), # updated with the datafile
                         sliderInput("value2", "Parameter value:", min=10, max=20, value=10),
                         strong(htmlOutput("plantTitle")),
                         htmlOutput("plantText"),
                         tags$hr(),
                         actionButton(inputId = "updateParams", label="Update root system", icon("refresh"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                         downloadButton("downloadParams", "")

                       ),

                       tabPanel( "Conductivities",
                         selectInput("roottype1", label = "Select root type", choices = c("Please load datafile")), # updated with the datafile
                         plotOutput("rootConductivities",
                                    height = "300px",
                                    click = "plot1_click"
                         ),
                         fluidRow(
                           column(4,
                                  textInput("x_input", "X value")
                           ),
                           column(4,
                                  textInput("y_input", "Y value")
                           ),
                           column(4,
                                  actionButton(inputId = "updateCond", label="", icon("refresh"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                           )
                         )
                       ),

                       tabPanel( "Environment",

                         fluidRow(
                           column(8,
                                  sliderInput("psiCollar", "Leaf water potential [Psi]:", min=-30000, max=0, value=-15000, step=1000)
                           ),
                           column(4,
                                  actionButton(inputId = "updateDemand", label="",
                                               icon("refresh"),
                                               style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                           )
                         ),
                         tags$hr(),
                         h4("Soil water potential"),
                         plotOutput("soilPlot",
                                    height = "500px",
                                    click = "plot2_click"
                         ),
                         fluidRow(
                           column(4,
                                  textInput("x_input_soil", "Psi")
                           ),
                           column(4,
                                  textInput("y_input_soil", "Depth")
                           ),
                           column(4,
                                  actionButton(inputId = "updateSoil", label="", icon("refresh"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                           )
                         )
                       )
                       )



                ),
                column(width = 8,

                       tabBox(
                         title = tagList(shiny::icon("leaf"), ""), width = NULL,

                         tabPanel("Root system representation",
                                  tags$hr(),
                                  fluidRow(
                                    column(6,
                                           selectInput("plotroottype", label = "What to display", choices = c("Root types" = 1,
                                                                                                              "Standart uptake fraction" = 2,
                                                                                                              "Water potential" = 3,
                                                                                                              "Axial fluxes" = 4,
                                                                                                              "Radial fluxes" = 5,
                                                                                                              "Radial conductivity" = 6,
                                                                                                              "Axial conductance" = 7), selected=1), # updated with the datafile
                                           selectInput("choosetype", label = NA, choices = c(""), selected = NULL, multiple = TRUE)
                                    ),
                                    column(6,
                                           conditionalPanel(
                                             condition = "input.plotroottype == 2",
                                             sliderInput("sufrange", "Display range (log):",min = 0, max = 1, value = c(0,1))
                                           ),
                                           conditionalPanel(
                                             condition = "input.plotroottype == 3",
                                             sliderInput("psirange", "Display range:",min = 0, max = 1, value = c(0,1))
                                           ),
                                           conditionalPanel(
                                             condition = "input.plotroottype == 4",
                                             sliderInput("jxlrange", "Display range:",min = 0, max = 1, value = c(0,1))
                                           ),
                                           conditionalPanel(
                                             condition = "input.plotroottype == 5",
                                             sliderInput("jrrange", "Display range:",min = 0, max = 1, value = c(0,1))
                                           )
                                    )
                                  ),
                                  plotOutput("rootPlot", height = "800px"),
                                  value=1
                         ),
                         tabPanel("Root depth profile",
                                  tags$hr(),
                                  selectInput("plotdensitytype", label = "What to display", choices = c("Length" = 1,
                                                                                                        "Standart uptake fraction" = 2,
                                                                                                        "Radial fluxes" = 3,
                                                                                                        "Axial fluxes" = 4,
                                                                                                        "Water potential" = 5)), # updated with the datafile
                                  plotOutput("densityPlot"),
                                  helpText("This plot show the root length profile for each root types. The bold lines represent the smooth density profile"),
                                  tags$hr(),
                                  value=2
                         ),
                         tabPanel("Simulations evolution",
                                  tags$hr(),
                                  selectInput("chooseEvol", label = "What to display", choices = c("Root system conductivity" = "krs",
                                                                                                   "Transpiration" = "tact",
                                                                                                   "Uptake depth" = "udepth")), # updated with the datafile
                                  plotlyOutput("evolPlot"),
                                  helpText("This plot show the value of Krs or Tact for the different simulation"),
                                  tags$hr(),
                                  value=2
                         ),
                         tabPanel("Download data",
                                  tags$hr(),
                                  tableOutput('table_results') ,
                                  tags$hr(),
                                  downloadButton("downloadRSML", "RSML"),
                                  downloadButton("downloadRootSys", "RootSys"),
                                  downloadButton("downloadCSV", "TXT"),
                                  downloadButton("downloadVTP", "VTP")

                         )
                       )


                       )
              )
      ),

      # View plant parameters
      tabItem(tabName = "tutorial",
              fluidRow(
                box(
                  status = "success", title = "How to use the interface", width=12,
                  tags$iframe(src = "https://www.youtube.com/embed/Y_qlC08hj88", width="560", height="315")
                )
              )
      ),


      # About tab content
      tabItem(tabName = "about",
              fluidRow(
                box(
                  title = "About MARSHAL", solidHeader = TRUE, width = 6, status = "primary",

                  helpText("MARSHAL is a maize root system hydraulic architecture solver which connects hydraulic macro-properties with root system architecture and soil water potential to compute hydraulic macro-properties of the all root system.

                           The model computes water flow at the level of root segments, quantifies the contribution of the water flows of each of the root segments, and predicts the whole conductivity of the root system (Krs) and the potential transpiration, as well as the actual one."),

                  tags$hr(),
                  helpText("The code of MARSHAL is open source and available here:"),
                  actionButton(inputId='ab1', label="Web application", icon = icon("code"), onclick ="window.open('https://github.com/MARSHAL-ROOT/marshal_shiny', '_blank')"),
                  actionButton(inputId='ab1', label="R package", icon = icon("code"), onclick ="window.open('https://github.com/MARSHAL-ROOT/marshal', '_blank')"),
                  actionButton(inputId='ab1', label="RMarkdown pipeline", icon = icon("code"), onclick ="window.open('https://github.com/MARSHAL-ROOT/marshal-pipeline', '_blank')")
                ),

                box(
                  title = "How to cite MARSHAL",  solidHeader = TRUE, width = 6, status = "warning",
                  tags$strong("MARSHAL, a unique tool for breeding virtual maize root system hydraulic architectures (2018)"),
                  helpText("Félicien Meunier1, Adrien Heymans, Xavier Draye, Mathieu Javaux and Guillaume Lobet"),
                  actionButton(inputId='ab1', label="View paper", icon = icon("flask"), onclick ="window.open('#', '_blank')")
                )

            ),
            fluidRow(
                box(
                  title = "GPL Licence",
                  helpText("Planet-Maize-Shiny is released under a GPL licence."),
                  helpText("
                           MARSHAL is released under a GPL licence, which means that redistribution and use in source and binary forms, with or without modification, are permitted under the GNU General Public License v3 and provided that the following conditions are met:

                           1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

                           2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

                           3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.")
                           ),
                box(
                  title =  "Disclaimer",
                  helpText("This software is provided by the copyright holders and contributors 'as is' and any express or implied warranties, including, but not limited to, the implied warranties of merchantability and fitness for a particular purpose are disclaimed. In no event shall the copyright holder or contributors be liable for any direct, indirect, incidental, special, exemplary, or consequential damages (including, but not limited to, procurement of substitute goods or services; loss of use, data, or profits; or business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of the use of this software, even if advised of the possibility of such damage.")
                )
              )
      )
    )
  )
)
