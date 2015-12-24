(require 'web)

(defgroup weatherline nil
  "Options for forecast mode"
  :prefix "forecast-")


(defconst forecast-geonames-service-endpoint "http://api.geonames.org/searchJSON?q=%s&maxRows=1&username=demo"
  "location of the geonames endpoint")


(defvar forecast-location-name "")

(defcustom forecast-coordinates nil
  ""
  :group 'forecast)

(defun forecast-geonames-service (for-location)
    (format forecast-geonames-service-endpoint for-location))

(defun forecast-parse-location (location-data)
  (let* ((geodata (aref (cdr (assoc 'geonames location-data)) 0))
         (lat (cdr (assoc 'lat geodata)))
         (lng (cdr (assoc 'lng geodata))))
    (customize-save-variable 'forecast-test (lat . lng))))

(defun forecast-get-location-coordinates ()
    (web-http-get (lambda (conn-proc header data)
                    (when (equal "200" (gethash 'status-code header))
                      (forecast-parse-location (web/json-parse data)))
                    (web/cleanup-process conn-proc))
                  :url (forecast-geonames-service forecast-location-name)))


(provide 'forecast-mode)
