(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}mkv/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mkv/i\u{0a}"))))
; /^\u{01}\u{02}.{0,50}[a-zA-Z]{10}\u{2f}PK.{0,50}[a-zA-Z]{10}\u{2f}[a-zA-Z]{7}\.classPK/sR
(assert (str.in_re X (re.++ (str.to_re "/\u{01}\u{02}") ((_ re.loop 0 50) re.allchar) ((_ re.loop 10 10) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "/PK") ((_ re.loop 0 50) re.allchar) ((_ re.loop 10 10) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "/") ((_ re.loop 7 7) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re ".classPK/sR\u{0a}"))))
; actualnames\.comclient\x2Ebaigoo\x2Ecomzzzvmkituktgr\u{2f}etiexpsp2-InformationHost\x3A
(assert (not (str.in_re X (str.to_re "actualnames.comclient.baigoo.comzzzvmkituktgr/etiexpsp2-InformationHost:\u{0a}"))))
; User-Agent\x3A\d+PortaURLSSKC\u{7c}roogoo\u{7c}\.cfgmPOPrtCUSTOMPal
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "PortaURLSSKC|roogoo|.cfgmPOPrtCUSTOMPal\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
