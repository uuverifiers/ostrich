(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \$?GP[a-z]{3,},([a-z0-9\.]*,)+([a-z0-9]{1,2}\*[a-z0-9]{1,2})
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (str.to_re "GP,") (re.+ (re.++ (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "."))) (str.to_re ","))) (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "a" "z")) (re.* (re.range "a" "z")) ((_ re.loop 1 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "*") ((_ re.loop 1 2) (re.union (re.range "a" "z") (re.range "0" "9")))))))
; alert\d+an.*Spyiz=e2give\.comrichfind\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "alert") (re.+ (re.range "0" "9")) (str.to_re "an") (re.* re.allchar) (str.to_re "Spyiz=e2give.comrichfind.com\u{0a}"))))
; Logger\w+gdvsotuqwsg\u{2f}dxt\.hd\dovplLogtraffbest\x2EbizAdToolsLoggedsidesearch\.dropspam\.com
(assert (str.in_re X (re.++ (str.to_re "Logger") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "gdvsotuqwsg/dxt.hd") (re.range "0" "9") (str.to_re "ovplLogtraffbest.bizAdToolsLoggedsidesearch.dropspam.com\u{0a}"))))
; /\u{2e}(jpg|png|gif)\u{3f}s?v.*?&tq=g[A-Z0-9]{2}/U
(assert (str.in_re X (re.++ (str.to_re "/.") (re.union (str.to_re "jpg") (str.to_re "png") (str.to_re "gif")) (str.to_re "?") (re.opt (str.to_re "s")) (str.to_re "v") (re.* re.allchar) (str.to_re "&tq=g") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
(check-sat)
