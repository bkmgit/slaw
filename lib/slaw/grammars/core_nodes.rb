module Slaw
  module Grammars
    class GroupNode < Treetop::Runtime::SyntaxNode
      def to_xml(b, id_prefix='')
        children.elements.each { |e| e.to_xml(b, id_prefix) }
      end
    end

    class Body < Treetop::Runtime::SyntaxNode
      def to_xml(b)
        b.body { |b|
          children.elements.each_with_index { |e, i| e.to_xml(b, '', i) }
        }
      end
    end
  end
end
