function keyPressCallback(source,eventdata)

      % determine the key that was pressed
      keyPressed = eventdata.Key

      if strcmpi(keyPressed,'w')
          mouseDrag
      end
end