(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}(css|upload)\u{2f}[a-z]{2}[0-9]{3}\u{2e}ccs/U
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.union (str.to_re "css") (str.to_re "upload")) (str.to_re "/") ((_ re.loop 2 2) (re.range "a" "z")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".ccs/U\u{0a}")))))
; dialupvpn\u{5f}pwd\x2Fiis2ebs\.aspOn-Line\x2E\x2E\x2EReport\x2Fnewsurfer4\x2FURLAuthorization\u{3a}
(assert (not (str.in_re X (str.to_re "dialupvpn_pwd/iis2ebs.aspOn-Line...Report/newsurfer4/URLAuthorization:\u{0a}"))))
; /META-INF.*?[a-zA-Z]{7}\.class/smi
(assert (not (str.in_re X (re.++ (str.to_re "/META-INF") (re.* re.allchar) ((_ re.loop 7 7) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re ".class/smi\u{0a}")))))
; ^[ \w\.]{3,}([A-Za-z]\.)?([ \w]*\##\d+)?(\r\n| )[ \w]{3,},\u{20}([A-Z]{2}\.)\u{20}\d{5}(-\d{4})?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (str.to_re "."))) (re.opt (re.++ (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "##") (re.+ (re.range "0" "9")))) (re.union (str.to_re "\u{0d}\u{0a}") (str.to_re " ")) (str.to_re ",  ") ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.union (str.to_re " ") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re " ") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 3 3) (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re ".")))))
(check-sat)
