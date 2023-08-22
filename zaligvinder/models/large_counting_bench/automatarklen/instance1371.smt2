(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /null[^\u{7d}]{0,50}\.body\.innerHTML\s*?\u{3d}\s*?[\u{22}\u{27}]{2}[^\u{7d}]{0,50}CollectGarbage\u{28}\s*?\u{29}[^\u{7d}]{0,250}document\.write\u{28}\s*?[\u{22}\u{27}]{2}/smi
(assert (not (str.in_re X (re.++ (str.to_re "/null") ((_ re.loop 0 50) (re.comp (str.to_re "}"))) (str.to_re ".body.innerHTML") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "\u{22}") (str.to_re "'"))) ((_ re.loop 0 50) (re.comp (str.to_re "}"))) (str.to_re "CollectGarbage(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ")") ((_ re.loop 0 250) (re.comp (str.to_re "}"))) (str.to_re "document.write(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/smi\u{0a}")))))
; /filename=[^\n]*\u{2e}jp2/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jp2/i\u{0a}")))))
; ^01[1,2,3,4,6,7,8,9]\d{7,8}$
(assert (not (str.in_re X (re.++ (str.to_re "01") (re.union (str.to_re "1") (str.to_re ",") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9")) ((_ re.loop 7 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Reports[^\n\r]*User-Agent\x3A.*largePass-Onseqepagqfphv\u{2f}sfd
(assert (str.in_re X (re.++ (str.to_re "Reports") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "largePass-Onseqepagqfphv/sfd\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
