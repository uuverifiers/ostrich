(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((((19|20)(([02468][048])|([13579][26])).02.29))|((20[0-9][0-9])|(19[0-9][0-9])).((((0[1-9])|(1[0-2])).((0[1-9])|(1[0-9])|(2[0-8])))|((((0[13578])|(1[02])).31)|(((0[1,3-9])|(1[0-2])).(29|30)))))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "19") (str.to_re "20")) (re.union (re.++ (re.union (str.to_re "0") (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8"))) (re.++ (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6")))) re.allchar (str.to_re "02") re.allchar (str.to_re "29")) (re.++ (re.union (re.++ (str.to_re "20") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9"))) re.allchar (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) re.allchar (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "8")))) (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) re.allchar (str.to_re "31")) (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re ",") (re.range "3" "9"))) (re.++ (str.to_re "1") (re.range "0" "2"))) re.allchar (re.union (str.to_re "29") (str.to_re "30")))))) (str.to_re "\u{0a}"))))
; /^User\u{2d}Agent\u{3a}\s*[^\n]*Safari[^\n]*\r\n/smi
(assert (not (str.in_re X (re.++ (str.to_re "/User-Agent:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re "Safari") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re "\u{0d}\u{0a}/smi\u{0a}")))))
; ^[\w0-9]+( [\w0-9]+)*$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ (str.to_re " ") (re.+ (re.union (re.range "0" "9") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "\u{0a}")))))
; /^\/\?[A-Za-z0-9_-]{15}=l3S/U
(assert (str.in_re X (re.++ (str.to_re "//?") ((_ re.loop 15 15) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (str.to_re "=l3S/U\u{0a}"))))
; ^\d{4}\/\d{1,2}\/\d{1,2}$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
