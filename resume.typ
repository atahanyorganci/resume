#set page(paper: "a4", margin: (left: 0cm, right: 0cm, top: 0.75cm, bottom: 0.75cm))
#set text(font: "Mulish")

#let primary = rgb(49,60,78)
#let secondary = rgb(68,147,153)

#show heading.where(level: 1): it => block(
    inset: (top: 4pt, bottom: 4pt),
    text(size: 16pt, weight: 700, hyphenate: false, upper(it))
)

#show heading.where(level: 2): it => text(size: 12pt, weight: 700, hyphenate: false, it)
#set block(above: 5pt, below: 5pt)
#set par(justify: true)

#let date_range2str(range) = {
    let start = range.start
    let end = "Present"
    if "end" in range {
        end = range.end
    }
    return start + " - " + end
}

#let decorated(width, height, margin, color, content) = grid(columns: (width, auto),
    rect(width: width, height: height, fill: color),
    block(inset: (left: margin, right: width + margin), content)
)

#let hero_section(content) = decorated(0.5cm, 39pt, 0.25cm, primary, {
    set block(above: 0pt, below: 0pt)
    par(text(primary, size: 25pt, weight: 600, content.name))
    v(10pt)
    par(text(secondary, size: 14pt, content.title))
    v(12pt)
    par(justify: true, text(size: 10pt, content.description))
})

#let quick_link(content, icon, href: none, order: "i-c", spacing: 4pt) = style(styles => {
    let size = measure(content, styles)
    let top = (size.height - 10pt) / 2
    let img = image(icon, width: 10pt, height: 10pt)
    let img_box = box(baseline: -top, inset: (left: spacing), img)
    let combined = block[#content #img_box]
    if order == "c-i" {
        combined = block[#img_box #content]
    }
    if href == none {
        combined
    } else {
        link(href, combined)
    }
})

#let quick_links(links) = align(right, block(inset: (right: 1.5cm), {
    set block(above: 12pt, below: 12pt)
    set text(10pt)
    if "email" in links {
        let href = "mailto:" + links.email
        quick_link(links.email, "icons/mail.png", href: href)
    }
    if "location" in links {
        quick_link(links.location, "icons/pin.png")
    }
    if "linkedin" in links {
        let bare = "linkedin.com/in/" + links.linkedin;
        let href = "https://" + bare;
        quick_link(bare, "icons/linkedin.png", )
    }
    if "github" in links {
        let bare = "github.com/" + links.github;
        let href = "https://" + bare;
        quick_link(bare, "icons/github.png", href: href)
    }
}))

#let institution(content) = {
    let date = date_range2str(content.dates)

    decorated(0.5cm, 30pt, 0.25cm, secondary, block(inset: (bottom: 4pt))[
        == #content.degree

        #par(justify: false, content.school)

        #if "gpa" in content {
            grid(columns: (1fr, auto, 1fr),
                align(left, text(secondary, size: 8pt, emph(content.location))),
                align(center, text(secondary, size: 8pt, emph("GPA: " + content.gpa))),
                align(right, text(secondary, size: 8pt, emph(date)))
            )
        } else {
            grid(columns: (1fr, auto),
                align(left, text(secondary, size: 8pt, emph(content.location))),
                align(right, text(secondary, size: 8pt, emph(date)))
            )
        }

        #if "notes" in content {
            for note in content.notes {
                [- #text(size: 10pt, note)]
            }
        }
    ])
}

#let education(content) = {
    block(inset: (left: 0.75cm), [= Education])
    for i in content {
        institution(i)
    }
}

#let work_place(content) = decorated(0.5cm, 30pt, 0.25cm, secondary, block(inset: (bottom: 6pt))[
    == #content.title

    #par(justify: false, content.company)

    #grid(columns: (1fr, auto),
        align(left, text(secondary, size: 8pt, emph(content.location))),
        align(right, text(secondary, size: 8pt, emph(date_range2str(content.dates))))
    )
    #if "companyDescription" in content {
        text(size: 8pt, fill: black.lighten(40%), content.companyDescription)
        parbreak()
    }
    #block(text(secondary, size: 10pt, emph("Achievements/Tasks")))
    #if "jobDescription" in content {
        block(text(size: 10pt, content.jobDescription))
    }
    #if "tasks" in content {
        for task in content.tasks {
            [- #eval("[" + task + "]")]
        }
    }
])

#let work_experience(content) = {
    block(inset: (left: 0.75cm), [= Work Experience])
    for i in content {
        work_place(i)
    }
}

#let pill(color, border_color, text_color, content) = {
    if text_color == none {
        text_color = black
    }
    let it = text(fill: text_color , content)
    let button = rect(fill: color, outset: (left: 1pt, right: 1pt), radius: 3pt, it)
    return box(inset: (left: 2pt, right: 2pt), button)
}

#let skills(arr) = {
    heading("Skills")
    for skill in arr {
        pill(primary, none, white, skill)
    }
}

#let personal_project(content) = block(inset: (bottom: 6pt, right: 0.75cm),{
    grid(columns: (1fr, auto),
        align(left, [== #content.name]),
        align(right + bottom, text(secondary, size: 8pt, emph(date_range2str(content.dates))))
    )
    eval("[" + content.description + "]")
    if "git" in content {
        quick_link("Repository", "icons/git.png", href: content.git, spacing: 2pt, order: "c-i")
    }
})

#let personal_projects(content) = {
    block(outset: (left: 0.75cm), [= Personal Projects])
    for i in content {
        personal_project(i)
    }
}

#let languages(content) = {
    set par(justify: false)
    heading("Languages")
    let content = content.map(it => block(inset: (bottom: 4pt), {
        par(it.name)
        par(text(secondary, size: 8pt, emph(it.level)))
        if "notes" in it {
            par(text(secondary, size: 8pt, emph(it.notes)))
        }
    }))
    grid(columns: (1fr, 1fr), ..content)
}

#let interests(content) = {
    block(outset: (left: 0.75cm), [= Interests])
    for i in content {
        pill(none, primary, none, i)
    }
}

#let content = json("content.json");

#grid(columns: (60%, 40%), hero_section(content), quick_links(content.links))
#v(0.25cm)
#line(length: 100%)

#show: rest => columns(2, rest)

#education(content.education)
#work_experience(content.workExperience)
#skills(content.skills)
#personal_projects(content.personalProjects)
#languages(content.languages)
#interests(content.interests)
