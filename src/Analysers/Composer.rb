module Analysers
    class Composer

        def initialize dir
            @directory = dir
        end

        def analyse
            `(cd #{directory}; composer outdated -D --no-ansi)`.lines.count
        end
    end
end
