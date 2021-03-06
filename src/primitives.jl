import Base: string

##################### XML #####################

function xml(r::Rect)
    parent = ElementNode("rect")

    addchildren!(parent, [
        "x" => string(r.x),
        "y" => string(r.y),
        "width" => string(r.width),
        "height" => string(r.height)])
    parent
end

function xml(sz::Size)
    parent = ElementNode("size")

    addchildren!(parent, [
        "width"  => string(sz.width),
        "height" => string(sz.height)])
    parent
end

function xml(policy::SizePolicy)
    hsizetype = titlecase(string(policy.hsizetype))
    vsizetype = titlecase(string(policy.vsizetype))
    parent = ElementNode("sizepolicy", ["hsizetype"=>hsizetype, "vsizetype"=>vsizetype])

    addchildren!(parent, [
        "horstretch"  => string(policy.horstretch),
        "verstretch" => string(policy.verstretch)])
    parent
end

function xml(font::Font)
    parent = ElementNode("font")

    addchildren!(parent, [
        "pointsize" => string(font.pointsize)])
    if font.weight != nothing
        addchildren!(parent, [
            "weight" => string(font.weight)])
    end
    addchildren!(parent, map(font.styles) do style
        lowercase(string(style)) => "true"
    end)
    parent
end

function string(alignment::Alignment)
    if     RIGHT == alignment
        "Qt::AlignRight"
    elseif LEFT == alignment
        "Qt::AlignLeft"
    elseif HCENTER == alignment
        "Qt::AlignHCenter"
    elseif VCENTER == alignment
        "Qt::AlignVCenter"
    elseif TRAILING == alignment
        "Qt::AlignTrailing"
    elseif LEADING == alignment
        "Qt::AlignLeading"
    elseif TOP == alignment
        "Qt::AlignTop"
    end
end

function xml(alignset::AlignmentSet)
    ElementNode("set", join(string.(alignset), '|'))
end

function xml(button_sym::ButtonSymbols)
    s = if     UP_DOWN_ARROWS == button_sym
            "QAbstractSpinBox::UpDownArrows"
        elseif PLUS_MINUS == button_sym
            "QAbstractSpinBox::PlusMinus"
        elseif NO_BUTTONS == button_sym
            "QAbstractSpinBox::NoButtons"
        end
    ElementNode("enum", s)
end

function xml(st::SizeType)
    s = if     PREFERRED == st
            "QSizePolicy::Preferred"
        elseif EXPANDING == st
            "QSizePolicy::Expanding"
        elseif FIXED == st
            "QSizePolicy::Fixed"
        end
    ElementNode("enum", s)
end

function xml(orientation::Orientation)
    s = if orientation == HORIZONTAL
            "Qt::Horizontal"
        elseif orientation == VERTICAL
            "Qt::Vertical"
        end
    ElementNode("enum", s)
end

function xml(format::TextFormat)
    s = if format == PLAIN_TEXT
            "Qt::PlainText"
        end
    ElementNode("enum", s)
end

xml(on::Bool) = ElementNode("bool", string(on))
xml(text::AbstractString) = ElementNode("string", text)
xml(num::Number) = ElementNode("number", string(num))
xml(num::AbstractFloat) = ElementNode("double", string(num))
