return function(inValue, acceptableValues)
    local isValid = false
    for i=1,#acceptableValues.clicks do
        if inValue == acceptableValues.clicks[i] then isValid = true end
    end
    for i=1,#acceptableValues.buttons do
        if inValue == acceptableValues.buttons[i] then isValid = true end
    end
    return isValid
end
