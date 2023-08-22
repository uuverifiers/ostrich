(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^-?([1-8]?[0-9]\.{1}\d{1,6}$|90\.{1}0{1,6}$)
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.opt (re.range "1" "8")) (re.range "0" "9") ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (str.to_re "90") ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (str.to_re "0")))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}emf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".emf/i\u{0a}"))))
; to\d+User-Agent\x3AFiltered
(assert (not (str.in_re X (re.++ (str.to_re "to") (re.+ (re.range "0" "9")) (str.to_re "User-Agent:Filtered\u{0a}")))))
; ShadowNet\dsearchreslt\sTROJAN-Host\x3AYWRtaW46cGFzc3dvcmQ
(assert (str.in_re X (re.++ (str.to_re "ShadowNet") (re.range "0" "9") (str.to_re "searchreslt") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "TROJAN-Host:YWRtaW46cGFzc3dvcmQ\u{0a}"))))
; ^p(ost)?[ |\.]*o(ffice)?[ |\.]*(box)?[ 0-9]*[^[a-z ]]*
(assert (str.in_re X (re.++ (str.to_re "p") (re.opt (str.to_re "ost")) (re.* (re.union (str.to_re " ") (str.to_re "|") (str.to_re "."))) (str.to_re "o") (re.opt (str.to_re "ffice")) (re.* (re.union (str.to_re " ") (str.to_re "|") (str.to_re "."))) (re.opt (str.to_re "box")) (re.* (re.union (str.to_re " ") (re.range "0" "9"))) (re.union (str.to_re "[") (re.range "a" "z") (str.to_re " ")) (re.* (str.to_re "]")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
