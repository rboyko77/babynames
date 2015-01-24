shinyServer(
	function(input, output, session) {

		my.years <- NULL
		my.freqs <- NULL
		my.data <- NULL
		my.genderNum <- 0
		filenames <- NULL 
	
		dataInput <- reactive({ 
	
			# Then find the data files we need to read
			# For now, just assume we know how to find the data
			fPath=paste("babydb/alberta/",input$gender,sep="")
	
			# Read the data for each year into R
			# Some of my data has extra white space in the names so strip.
			filenames = list.files(fPath, pattern="*.csv", full.names=TRUE)
			for (i in 1:length(filenames)) {
				my.data[[i]] <<- read.csv(filenames[[i]], strip.white=TRUE)
			}
			dataInput <- filenames
    	})

		output$freqPlot <- renderPlot({
	
			# Only execute when submit button is pressed
			if (input$goButton == 0)
				return()
	
			isolate ({
	
			# Do we need to read in updated data?
			filenames <- dataInput()
	
			# What name is the user searching for
   			my.query <- tolower(input$queryStr)
	
			# For each year of data find the frequency for the user search name
			for (i in 1:length(filenames)) {
	
				# Get the frequency from the data for a particular name/year
				data <- my.data[[i]]
				freqStr = data[tolower(data$Name) == my.query,]
				
				# If we don't find the name, then our frequency is zero 
				freq = 0;
				if (length(freqStr$Freq) > 0) {
					freq = as.numeric(as.matrix(freqStr$Freq));
				}
	
				# Add to our vector of data years 
				yearStr <- strsplit(basename(filenames[i]), "_", fixed = TRUE)[[1]]
				my.years <- c(my.years, yearStr[1])
	
				# Add to our vector of frequencies 
				my.freqs = c(my.freqs, freq)
			}
	
			# All set to plot it out
			y = setNames(my.freqs, my.years)
			mainTitle = paste("Gender:",input$gender, "  Name:", input$queryStr, sep=" ")
   			barplot(y, main=mainTitle, ylab="Frequency", xlab="Year")
	
			})
		})
	}
)
