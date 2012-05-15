module Pedal
  def self.render_error(code, req, res, options={})
    res.code = code
    unless res.body
      res.body = "Not found\n"
      res.headers['Content-Type'] = "text/html"
    end
  end
end
