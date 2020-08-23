# YACHT
**YAml Configured HTml**

(Work in progress)

`yacht` is a command line interface for building static html sites.
The idea is to create html templates ("components") with replacable variables to create multiple pages of the same style without having to duplicate code.

The html pages are configured with a file `yacht.yaml`. Run
```
yacht
```
from the root of the yacht project.

```yaml
# yacht.yaml
output: output
pages:
  page1:
    name: index.html
    styles:
      - main.css
      - fonts.css
    layout:
      a:
        template: header.html
        variables:
          icon: icon.png
      b:
        template: main.html
        variables:
          title: "Lorem Ipsum"
          content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum ac justo..."
```

```html
<!-- header.html -->
<header>
  <img src="{{icon}}">
</header>
```

```html
<!-- main.html -->
<main>
  <h1>{{title}}</h1>
  <p>
    {{content}}
  </p>
</main>
```

### Structure
```
> root
  yacht.yaml
  > styles
     main.css
     fonts.css
  > templates
     header.html
     main.html
```

## Installation
I suggest using [`smash`](https://github.com/fippli/smash) to install the script.
Install `smash` and run
```
smash install https://github.com/fippli/yacht.git
```

## Contribution
Contributions are welcome!
Feel free to open an issue or pull request to help improve yacht.
