(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((((0031)|(\+31))(\-)?6(\-)?[0-9]{8})|(06(\-)?[0-9]{8})|(((0031)|(\+31))(\-)?[1-9]{1}(([0-9](\-)?[0-9]{7})|([0-9]{2}(\-)?[0-9]{6})))|([0]{1}[1-9]{1}(([0-9](\-)?[0-9]{7})|([0-9]{2}(\-)?[0-9]{6}))))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "0031") (str.to_re "+31")) (re.opt (str.to_re "-")) (str.to_re "6") (re.opt (str.to_re "-")) ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (str.to_re "06") (re.opt (str.to_re "-")) ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (re.union (str.to_re "0031") (str.to_re "+31")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "1" "9")) (re.union (re.++ (re.range "0" "9") (re.opt (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 6 6) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (str.to_re "0")) ((_ re.loop 1 1) (re.range "1" "9")) (re.union (re.++ (re.range "0" "9") (re.opt (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 6 6) (re.range "0" "9")))))) (str.to_re "\u{0a}"))))
; /\/se\/[a-f0-9]{100,200}\/[a-f0-9]{6,9}\/[A-Z0-9_]{4,200}\.com/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//se/") ((_ re.loop 100 200) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 6 9) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 4 200) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (str.to_re ".com/Ui\u{0a}")))))
; spyblpat.*is[^\n\r]*BarFrom\x3AHost\x3Agdvsotuqwsg\u{2f}dxt\.hdPASSW=
(assert (not (str.in_re X (re.++ (str.to_re "spyblpat") (re.* re.allchar) (str.to_re "is") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "BarFrom:Host:gdvsotuqwsg/dxt.hdPASSW=\u{0a}")))))
; /^"|'+(.*)+"$|'$/
(assert (str.in_re X (re.union (str.to_re "/\u{22}") (re.++ (re.+ (str.to_re "'")) (re.+ (re.* re.allchar)) (str.to_re "\u{22}")) (str.to_re "'/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
