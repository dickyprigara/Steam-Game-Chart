library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$visual1 <- renderPlotly({
        # Praproses data
        
        data_agg1 <- games_clean %>% 
            filter(year==input$yearchoice) %>% 
            select(gamename,avg,year,gain) %>% 
            group_by(gamename) %>%
            summarise(avg_sum=sum(avg),avg_per=mean(avg),avg_percent=sum(gain)) %>% 
            arrange(-avg_sum)
            
        # visualisasi
        
        plot1 <- ggplot(head(data_agg1), aes(x=avg_sum,y = reorder(gamename,avg_sum)))+
            geom_col(aes(fill=gamename),
                     fill="salmon")+
            # scale_fill_gradient(low = "white", high = "salmon")+
            theme(legend.position = "none")+
            labs(title = paste("Top 6 Popular Game in",input$yearchoice),#input$year), 
                 y = NULL, 
                 x = "Average Player in One Year")
        
        # Interaktif
        
        ggplotly(plot1,tooltip = NULL)%>% 
            config(displayModeBar = F)
        
    })
    
    output$visual2 <- renderPlotly({
        #Praproses Data
        
        data_agg1 <- games_clean %>% 
            filter(year==input$yearchoice) %>% 
            select(gamename,avg,year,gain) %>% 
            group_by(gamename) %>%
            summarise(avg_sum=sum(avg),avg_per=mean(avg),avg_percent=sum(gain)) %>% 
            arrange(-avg_sum)
        
        var1 <- head(data_agg1)

        data_agg2 <- games_clean %>%
            filter (gamename %in% var1$gamename) %>%
            filter(year == input$yearchoice) %>%
            group_by(gamename,month) %>%
            select(gamename,month,peak) %>%
            summarise(max_peak = max(peak)) %>%
            # mutate(max_peak = format(as.numeric(max_peak),big.mark=",")) %>% %>%  
            filter(gamename %in% unique(gamename)) %>%
            arrange(-max_peak,gamename) %>%
            filter(row_number()==1)  
            
            

        # Visualisasi

        plot2 <- ggplot(data_agg2, aes(y = reorder(gamename, max_peak ),
                                       x = max_peak,
                                       text=glue("Max Peak Player: {max_peak}
                                                 Month: {month}")
        )
        ) +
            geom_segment(aes(xend = 0, yend = gamename)
                         ) +
            scale_x_continuous(labels = comma)+
            # scale_y_continuous(labels=comma)+
            geom_point( color="firebrick4", size=3) +
            theme_minimal() +
            labs(title = paste("Max Peak Player in Each Top 6 Game in",input$yearchoice),
                 y = NULL,
                 x = NULL)+
            theme(plot.title = element_text(hjust = 1, vjust=1.12))

        # Interactive
        ggplotly(plot2, tooltip = "text") %>%
            config(displayModeBar = F)
    })

    output$visual3 <- renderPlotly({
        #Preprocessing
        # data_agg1 <- games_clean %>% 
        #     filter(year==input$yearchoice) %>% 
        #     select(gamename,avg,year,gain) %>% 
        #     group_by(gamename) %>%
        #     summarise(avg_sum=sum(avg),avg_per=mean(avg),avg_percent=sum(gain)) %>% 
        #     arrange(-avg_sum)
        # 
        # var1 <- head(data_agg1)

        data_agg3 <- games_clean %>%
            filter (gamename %in% input$game1) %>%
            filter(year==input$slide) %>%
            group_by(gamename,year) %>%
            arrange(year,-gain,-peak)

        #Visualization

        plot3 <- ggplot(data_agg3,aes(x = month,
                                      y = peak,
                                      col=gamename,
                                      group = gamename))+
            geom_line()+
            geom_point(aes( text = glue("Game Name: {gamename}
                                        Gain: {peak}")))+
            theme_minimal() +
            theme(legend.position = "none") +
            scale_color_brewer(palette = "Set1") +
            # scale_y_continuous(labels = percent_format()) +
            labs(title = paste("Player Gain in",input$slide),
                 y = NULL,
                 x = NULL)+
            validate(
                need(input$game1, "Please select a input game")
            )

        #Interactive Plot

        ggplotly(plot3,tooltip = "text")
        
        

    })

    output$visual4 <- renderPlotly({
        #Preprocessing
        data_agg1 <- games_clean %>% 
            filter(year==input$yearchoice) %>% 
            select(gamename,avg,year,gain) %>% 
            group_by(gamename) %>%
            summarise(avg_sum=sum(avg),avg_per=mean(avg),avg_percent=sum(gain)) %>% 
            arrange(-avg_sum)
        
        var1 <- head(data_agg1)

        event <- c("Feb","May","Jun","Oct","Nov","Dec")
        salesteam<- games_clean %>%
            filter (gamename %in%  input$game1) %>%
            filter(year==input$slide) %>%
            filter(month %in% event) %>%
            select(gamename,sale,avg) %>%
            group_by(gamename) %>%
            ungroup()

        #Visualization

        plot4 <- ggplot(salesteam,
                        aes(x=avg,
                            y = reorder(gamename,avg)))+
            geom_col(aes(fill=sale,  text=glue("Player Gain: {avg}")),
                     position="dodge"

            )+
            # theme(legend.position = "none")+
            labs(title = paste("Player Gain in Steam Sale",input$slide),
                 y = NULL,
                 x = "Average Player in One Time Sale")+
            validate(
                need(input$game1, "Please select a input game")
            )

        #Interactive Plot

        ggplotly(plot4,tooltip = "text")%>%
            config(displayModeBar = F)
    })

    output$data <- renderDataTable({
        games_clean %>% 
            select(-yearmonth)
    })
    
    
    
})
