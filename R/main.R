title <- "任意のタイトル"
title <- "入門機械学習による異常検知"

#'
#' documentation target files
#' 
input.files <- c(
  "chapter1.Rmd"
  , "chapter2.Rmd"
  # "HotellingsTheory.Rmd"
#   , "GammaDistFitting.Rmd"
#   , "section3.2.R"
)

# output.format <- "html_document" 
output.format <- "pdf_document"
# output.format <- "beamer_presentation"
output.file.name.body <- "DefaultReport"
output.suffix <- switch(EXPR = output.format,
                        "html_document" = ".html"
                        , "pdf_document" = ".pdf"
                        , "beamer_presentation" = ".pdf"
                        , "all" = ""
)

output.dir <- "output"
if (!file.exists(output.dir)){
  dir.create(path = output.dir, recursive = T)
}


#' 
#' temporaly files
#' 
template.file.name <- "main_template.Rmd"
render.target <- "main.Rmd"

# if (file.exists(render.target)){
#   stop(paste0(render.target, " already exists."))
# }

#' creating render target Rmd file
file.copy(from = template.file.name, to = render.target, overwrite = T)
for (i in input.files) {
  write(x = paste0('```{r child = "', i, '"}\r\n```'), file = render.target, append = T)
}
rmarkdown::render(
  output_format = output.format
  , output_file = paste0(output.file.name.body, output.suffix)
  , input = render.target
  , output_dir = output.dir
  , encoding = "utf-8"
)

#' 
#' cleaning
#' 
file.remove(render.target)
