
<!-- README.md is generated from README.qmd. Please edit that file -->

# CMU SURE Program 2023 <a href='https://compasp23.classes.andrewheiss.com/'><img src='/files/cmu-statds-icon-hex-2.png' align="right" height="139" /></a>

[Sure 2023 • Summer 2023](https://compasp23.classes.andrewheiss.com/)  
Department of Statistics & Data Science • Carnegie Mellon University

------------------------------------------------------------------------

**[Quarto](https://quarto.org/) +
[{targets}](https://docs.ropensci.org/targets/) +
[{renv}](https://rstudio.github.io/renv/) = magic! 🪄**

------------------------------------------------------------------------

## How to build the site

1.  Install
    [RStudio](https://www.rstudio.com/products/rstudio/download/#download)
    version 2022.07.1 or later since it has a
    [Quarto](https://quarto.org/) installation embedded in it.
    Otherwise, download and install [Quarto](https://quarto.org/)
    separately.
2.  Open `compasp23.Rproj` to open an [RStudio
    Project](https://r4ds.had.co.nz/workflow-projects.html).
3.  If it’s not installed already, R *should* try to install the [{renv}
    package](https://rstudio.github.io/renv/) when you open the RStudio
    Project for the first time. If you don’t see a message about package
    installation, install it yourself by running
    `install.packages("renv")` in the R console.
4.  Run `renv::restore()` in the R console to install all the required
    packages for this project.
5.  Run `targets::tar_make()` in the R console to build everything.
6.  🎉 All done! 🎉 The complete website will be in a folder named
    `_site/`.

## {targets} pipeline

I use the [{targets} package](https://docs.ropensci.org/targets/) to
build this site and all its supporting files. The complete pipeline is
defined in [`_targets.R`](_targets.R) and can be run in the R console
with:

``` r
targets::tar_make()
```

The pipeline does several major tasks:

- **Build Quarto website**: This project is a [Quarto
  website](https://quarto.org/docs/websites/), which compiles and
  stitches together all the `.qmd` files in this project based on the
  settings in [`_quarto.yml`](_quarto.yml). See the [Quarto website
  documentation](https://quarto.org/docs/websites/) for more details.

- **Upload resulting `_site/` folder to my remote server**: Quarto
  places the compiled website in a folder named `/_site/`. The pipeline
  uses `rsync` to upload this folder to my personal remote server. This
  target will only run if the `UPLOAD_WEBSITES` environment variable is
  set to `TRUE`, and it will only work if you have an SSH key set up on
  my personal server, which only I do.

The complete pipeline looks like this:

<small>(This uses [`mermaid.js`
syntax](https://mermaid-js.github.io/mermaid/) and should display as a
graph on GitHub. You can also view it by pasting the code into
<https://mermaid.live>.)</small>

``` mermaid
graph LR
  subgraph Graph
    direction LR
    x9c20b8c56debbe9a(["deploy_script"]):::skipped --> x78f3e0b711425f1c(["deploy_site"]):::queued
    x7aa56383a054e8ba(["site"]):::queued --> x78f3e0b711425f1c(["deploy_site"]):::queued
    x4a210bdf90796bca(["xaringan_files_files"]):::built --> xf4774655f169db90["xaringan_files"]:::queued
    x4d31f5a49d5ae49f(["schedule_ical_file"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    x063edd335cc1b36f(["schedule_page_data"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    xccbb2c85646c611a["xaringan_pdfs"]:::queued --> x7aa56383a054e8ba(["site"]):::queued
    x60c212b45249134a["xaringan_slides"]:::queued --> x7aa56383a054e8ba(["site"]):::queued
    xf38d3f5e6365ad72(["workflow_graph"]):::started --> x6e52cb0f1668cc22(["readme"]):::queued
    x0751853b619def05["xaringan_html_files"]:::queued --> xccbb2c85646c611a["xaringan_pdfs"]:::queued
    xdf832f8e1f99baf2(["schedule_file"]):::queued --> x063edd335cc1b36f(["schedule_page_data"]):::queued
    xf4774655f169db90["xaringan_files"]:::queued --> x60c212b45249134a["xaringan_slides"]:::queued
    xdf832f8e1f99baf2(["schedule_file"]):::queued --> x35552a73efe9c59f(["schedule_ical_data"]):::queued
    x7a0d40becb063bda(["xaringan_html_files_files"]):::queued --> x0751853b619def05["xaringan_html_files"]:::queued
    x35552a73efe9c59f(["schedule_ical_data"]):::queued --> x4d31f5a49d5ae49f(["schedule_ical_file"]):::queued
    x60c212b45249134a["xaringan_slides"]:::queued --> x7a0d40becb063bda(["xaringan_html_files_files"]):::queued
  end
```

## Fonts and colors

The font used throughout the site is [Public
Sans](https://public-sans.digital.gov/), an open source font developed
as part of the General Services Administration’s
[USWDS](https://designsystem.digital.gov/) (US Web Design System) for
making accessible federal government websites.

The colors for the site and hex logo come from the [Tam
palette](https://github.com/BlakeRMills/MetBrewer#tam) in
[MetBrewer](https://github.com/BlakeRMills/MetBrewer)
(`MetBrewer::met.brewer("Tam")`):

<img src="README_files/figure-commonmark/show-tam-1.png" width="768" />

## Licenses

**Text and figures:** All prose and images are licensed under Creative
Commons ([CC-BY-NC
4.0](https://creativecommons.org/licenses/by-nc/4.0/))

**Code:** All code is licensed under the [MIT License](LICENSE.md).
