(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}swf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".swf/i\u{0a}"))))
; /\r\nLocation\u{3a}\u{20}https\u{3a}\u{2f}{2}dl\.dropboxusercontent\.com\/[a-zA-Z\d\u{2f}]{5,32}\/avcheck\.exe\r\n\r\n$/H
(assert (not (str.in_re X (re.++ (str.to_re "/\u{0d}\u{0a}Location: https:") ((_ re.loop 2 2) (str.to_re "/")) (str.to_re "dl.dropboxusercontent.com/") ((_ re.loop 5 32) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "/"))) (str.to_re "/avcheck.exe\u{0d}\u{0a}\u{0d}\u{0a}/H\u{0a}")))))
; http://www.scribd.com/doc/2569355/Geo-Distance-Search-with-MySQL
(assert (not (str.in_re X (re.++ (str.to_re "http://www") re.allchar (str.to_re "scribd") re.allchar (str.to_re "com/doc/2569355/Geo-Distance-Search-with-MySQL\u{0a}")))))
(check-sat)
