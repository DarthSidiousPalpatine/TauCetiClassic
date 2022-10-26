import { useBackend } from '../backend';
import { Button, Box } from "../components";
import { Window } from '../layouts';

const num_to_color = {
  " ": "#ffffff",
  "1": "#0092cc",
  "2": "#779933",
  "3": "#ff3333",
  "4": "#087099",
  "5": "#cc3333",
  "6": "#A6B2EC",
  "7": "#600095",
  "8": "#E5E5E5",
};

function makeButtonContent(text) {
  return (
    <Box className="Minesweeper__Button-Content">
      {text}
    </Box>
  )
}

export const Minesweeper = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    width,
    height,
    grid,
    mines,
  } = data;
  return (
    <Window width={width} height={height + 32} title={mines}>
      <Window.Content fitted>
        {grid.map(line => (
          <>
            {line.map((butn, index) => (
              <Button className="Minesweeper__Button"
                key={index}
                disabled={butn.state === 'empty' ? true : false}
                textColor={num_to_color[butn.nearest]}
                icon={butn.flag ? 'flag' : ''}
                iconColor='red'
                children={makeButtonContent(butn.nearest)}
                onClick={() => act('button_press', { choice_x: butn.x, choice_y: butn.y })}
                onContextMenu={e => {
                  e.preventDefault();
                  act('mark_flag', { choice_x: butn.x, choice_y: butn.y });
                }}
              />
            ))}
            <br />
          </>
        ))}
      </Window.Content>
    </Window>
  );
};
