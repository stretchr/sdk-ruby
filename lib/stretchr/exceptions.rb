#FIXME : Right now we just define some errors that users can implement if they wish.  Should we implement them for them?
class Stretchr::NotFound < StandardError
end
class Stretchr::Unknown < StandardError
end