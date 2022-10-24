function Vector()
    local o_angle = 0
    local o_magnitude = 0
    local PI = math.pi

    local function radians(angle)
        return ((angle*PI)/360)
    end

    return{
        angle = o_angle,
        magnitude = o_magnitude,
        Scale = function (self,factor)
            self.magnitude = self.magnitude * factor
        end,
        Rotate = function (self,theta)
            self.angle = self.angle - theta
            while (self.angle <0 or self.angle > 360) do
                if self.angle >= 360 then
                    self.angle = self.angle -360
                else
                    self.angle = self.angle + 360
                end
               
            end
        end,
        XComponent = function (self)
            return (self.magnitude * math.cos(radians(self.angle)))
        end,
        YComponent = function (self)
            return (self.magnitude * math.sin(radians(self.angle)))
        end,
        RotateTo = function (self,value)
            self.angle =  value
        end,
        ScaleTo = function (self,value)
            self.magnitude =  value
        end,
        Add = function (self,v)
            local rx = self.XComponent() + v.XComponent()
            local ry = self.YComponent() + v.YComponent()

            self.magnitude = math.sqrt(rx^2 + ry^2)

            if rx > 0 then
                if ry >= 0 then
                    self.angle = math.atan(rx/ry)
                    self.angle = ((180 * self.angle)/self.PI)
                else
                    self.angle = math.atan(rx/ry)
                    self.angle = ((180 * self.angle)/self.PI) + 360
                end
            elseif rx < 0 then
                self.angle = math.atan(ry/rx)
                self.angle = ((180 * self.angle)/self.PI) + 180
            else
                if ry>0 then
                    self.angle = 90
                elseif ry<0 then
                    self.angle =  270
                else
                    self.angle = v.angle
                end
            end

        end
      
    }
    
   
end
return Vector