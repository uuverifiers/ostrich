(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; to=.*JMail\d+HXDownloadasdbiz\x2EbizUser-Agent\x3Awww\x2Eezula\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "to=") (re.* re.allchar) (str.to_re "JMail") (re.+ (re.range "0" "9")) (str.to_re "HXDownloadasdbiz.bizUser-Agent:www.ezula.com\u{0a}"))))
; /myversion\u{7c}(\d\u{2e}){3}\d\u{0d}\u{0a}/
(assert (str.in_re X (re.++ (str.to_re "/myversion|") ((_ re.loop 3 3) (re.++ (re.range "0" "9") (str.to_re "."))) (re.range "0" "9") (str.to_re "\u{0d}\u{0a}/\u{0a}"))))
; eveocczmthmmq\u{2f}omzlHello\x2E\x2Fasp\x2Foffers\.asp\?
(assert (not (str.in_re X (str.to_re "eveocczmthmmq/omzlHello./asp/offers.asp?\u{0a}"))))
(check-sat)
