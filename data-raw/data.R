devtools::load_all()

EM_ALL %>%
    subset(SOURCE != "CDC") %>%
    mutate(
        SUBGROUP = as.character(SUBGROUP),
        GROUP = gsub("[A-Z]", "", GROUP) %>% as.integer(),
        SUBGROUP = ifelse(grepl("9", GROUP), gsub("\\s", " REGION ", SUBGROUP), SUBGROUP) %>%
            gsub("HR", "HEART", .) %>%
            gsub("KI", "KIDNEY", .) %>%
            gsub("LI", "LIVER", .) %>%
            gsub("LU", "LUNG", .) %>%
            paste0("(", GROUP, ") ", .)
    ) %>%
    arrange(GROUP) -> data

usethis::use_data(data, overwrite = T)
