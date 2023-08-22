(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(.|\n){0,16}$
(assert (not (str.in_re X (re.++ ((_ re.loop 0 16) (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re "\u{0a}")))))
; ^[1-9][0-9]{3}[ ]?(([a-rt-zA-RT-Z]{2})|([sS][^dasDAS]))$
(assert (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) (re.union ((_ re.loop 2 2) (re.union (re.range "a" "r") (re.range "t" "z") (re.range "A" "R") (re.range "T" "Z"))) (re.++ (re.union (str.to_re "s") (str.to_re "S")) (re.union (str.to_re "d") (str.to_re "a") (str.to_re "s") (str.to_re "D") (str.to_re "A") (str.to_re "S")))) (str.to_re "\u{0a}"))))
; rprpgbnrppb\u{2f}ci\d\x2ElStopperHost\x3AHost\u{3a}clvompycem\u{2f}cen\.vcn
(assert (not (str.in_re X (re.++ (str.to_re "rprpgbnrppb/ci") (re.range "0" "9") (str.to_re ".lStopperHost:Host:clvompycem/cen.vcn\u{0a}")))))
; (([\n,  ])*((<+)([^<>]+)(>*))+([\n,  ])*)+
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.* (re.union (str.to_re "\u{0a}") (str.to_re ",") (str.to_re " "))) (re.+ (re.++ (re.+ (str.to_re "<")) (re.+ (re.union (str.to_re "<") (str.to_re ">"))) (re.* (str.to_re ">")))) (re.* (re.union (str.to_re "\u{0a}") (str.to_re ",") (str.to_re " "))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
