(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^Subject\x3A[^\r\n]*Trojaner-Info\sNewsletter/smi
(assert (not (str.in_re X (re.++ (str.to_re "/Subject:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "Trojaner-Info") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Newsletter/smi\u{0a}")))))
; /^\d{2}[\-\/]\d{2}[\-\/]\d{4}$/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re "/")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re "/")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/\u{0a}"))))
; ^\d{3}\s?\d{3}$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; tid\x3D\x7B\s+Basic.*\x2Ftoolbar\x2F
(assert (not (str.in_re X (re.++ (str.to_re "tid={") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Basic") (re.* re.allchar) (str.to_re "/toolbar/\u{0a}")))))
; Host\x3A\s+Online100013Agentsvr\x5E\x5EMerlin
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Online100013Agentsvr^^Merlin\u{13}\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
