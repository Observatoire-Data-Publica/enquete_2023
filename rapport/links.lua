function Link(element)

    if 
        string.sub(element.target, 1, 1) ~= "#"
    then
        element.attributes.target = "_blank"
    end
    return element

end

