function [immagine] = ritaglio(image)
    %{
    In input prendi un immagine in formato scala di grigi, da questa
    vengono trovati i vari angoli definiti dal primo punto non nullo e se
    ne ritaglia l'immagine che poi verrà restituita in output.
    %}
    [row, col] = find(image);
    immagine = image(min(row(:))+1:max(row(:)), min(col(:)):max(col(:)));
end