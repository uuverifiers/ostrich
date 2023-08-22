(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (0?[1-9]|[12][0-9]|3[01])-(0?[1-9]|1[012])-((19|20)\\d\\d)
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "-") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (str.to_re "-\u{0a}") (re.union (str.to_re "19") (str.to_re "20")) (str.to_re "\u{5c}d\u{5c}d"))))
; /User-Agent\u{3a}\u{20}[^\u{0d}\u{0a}]*?\u{3b}U\u{3a}[^\u{0d}\u{0a}]{1,68}\u{3b}rv\u{3a}/H
(assert (str.in_re X (re.++ (str.to_re "/User-Agent: ") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ";U:") ((_ re.loop 1 68) (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ";rv:/H\u{0a}"))))
; ppcdomain\x2Eco\x2Euk\s+ready\w+PARSERHost\u{3a}A-311ServerUser-Agent\x3Ascn\u{2e}mystoretoolbar\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "ppcdomain.co.uk") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ready") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "PARSERHost:A-311ServerUser-Agent:scn.mystoretoolbar.com\u{13}\u{0a}")))))
; /^(\u{00}\u{00}\u{00}\u{00}|.{4}(\u{00}\u{00}\u{00}\u{00}|.{12}))/s
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{00}\u{00}\u{00}\u{00}") (re.++ ((_ re.loop 4 4) re.allchar) (re.union (str.to_re "\u{00}\u{00}\u{00}\u{00}") ((_ re.loop 12 12) re.allchar)))) (str.to_re "/s\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
