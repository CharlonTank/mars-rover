# Mars Rover

Simulates robots moving on a 2D grid on Mars. Each robot has:

- A position `(x, y)`
- An orientation (`N`, `E`, `S`, `W`)
- A set of commands:
  - **F** (move forward)
  - **L** (turn left)
  - **R** (turn right)

If a robot tries to leave the grid, it becomes LOST.

## Example

**Input:**
```
4 8
(2, 3, E) LFRFF
(0, 2, N) FFLFRFF
```

**Output:**
```
(4, 4, E)
(0, 4, W) LOST
```

## Setup

1. **Install Deno**:
   ```bash
   brew install deno
   ```

2. **Install Elm Script:**
   ```bash
   deno install -g -f -A -n elm-script https://elm-script.github.io/latest
   ```

3. **Add elm-script to your PATH:**
   ```bash
   # For zsh:
   echo 'export PATH="$HOME/.deno/bin:$PATH"' >> ~/.zshrc
   
   # For fish:
   fish_add_path "$HOME/.deno/bin"
   ```

4. **Install elm-test-rs**:
   ```bash
   npm install -g elm-test-rs
   ```

## Run

**Interactive mode:**
```bash
elm-script run src/MarsRover.elm (press enter to run)
4 8
(2, 3, E) LFRFF
(0, 2, N) FFLFRFF
```

**Via command-line arguments:**
```bash
elm-script run src/MarsRover.elm "4 8" "(2, 3, E) LFRFF" "(0, 2, N) FFLFRFF"
```

**Single line:**
```bash
elm-script run src/MarsRover.elm "4 8\n(2, 3, E) LFRFF\n(0, 2, N) FFLFRFF"
```

## Tests

```bash
elm-test-rs
```

## What Next?

- **Collisions:** Track multiple robots simultaneously and detect collisions
- **Steps:** Introduce steps so you can watch them move/turn in sequence
- **Visual Grid:** Create a graphical or web-based UI rather than a text-only script
- **New Commands:** Extend movement with "Jump," "Shoot," or other creative actions
- **Bigger Test Suite:** Add more scenarios—edge cases, collisions, large grids, etc.
