MUXPATH="/root/multiplex/SVC_layer_multiplexer/Multiplex"
DECODERPATH="/root/multiplex/SVC_layer_multiplexer/H264AVCDecoderLibTestStatic"
if [ -e files_to_concat.txt ]; then
    rm files_to_concat.txt
fi
touch files_to_concat.txt    
for segment in {00..99}
do 
  layers=$(ls -1 | grep "_$(printf %02d ${segment#0}).svc" | wc -l)
  if [ $layers -eq 1 ]; then
    $MUXPATH layer0"_$(printf %02d "${segment#0}").svc" -n 0
    $DECODERPATH final_output.264 segment-"$(printf %03d ${segment#0}).yuv"
    ffmpeg -f rawvideo -s:v 1920x1080 -r 1.5 -i segment-"$(printf %03d ${segment#0}).yuv" -c:v segment-"$(printf %03d ${segment#0})".mp4
    echo 'file "$(printf %03d ${segment#0})".mp4\n' >> files_to_concat
  fi
  if [ $layers -eq 2 ]; then
    $MUXPATH layer0"_$(printf %02d "${segment#0}").svc" -n 1 layer1"_$(printf %02d "${segment#0}").svc"
    $DECODERPATH final_output.264 segment-"$(printf %03d ${segment#0}).yuv"
    ffmpeg -f rawvideo -s:v 1920x1080 -r 24 -i segment-"$(printf %03d ${segment#0}).yuv" -c:v segment-"$(printf %03d ${segment#0})".mp4
    echo 'file "$(printf %03d ${segment#0})".mp4\n' >> files_to_concat
  fi
done

for segment in {100..300}
do 
  layers=$(ls -1 | grep "_$(printf %02d ${segment#0}).svc" | wc -l)
  if [ $layers -eq 1 ]; then
    $MUXPATH layer0"_$(printf %02d "${segment#0}").svc" -n 0
    $DECODERPATH final_output.264 segment-"$(printf %03d ${segment#0}).yuv"
    ffmpeg -f rawvideo -s:v 1920x1080 -r 1.5 -i segment-"$(printf %03d ${segment#0}).yuv" -c:v segment-"$(printf %03d ${segment#0})".mp4
    echo 'file "$(printf %03d ${segment#0})".mp4\n' >> files_to_concat
  fi
  if [ $layers -eq 2 ]; then
    $MUXPATH layer0"_$(printf %02d "${segment#0}").svc" -n 1 layer1"_$(printf %02d "${segment#0}").svc"
    $DECODERPATH final_output.264 segment-"$(printf %03d ${segment#0}).yuv"
    ffmpeg -f rawvideo -s:v 1920x1080 -r 24 -i segment-"$(printf %03d ${segment#0}).yuv" -c:v segment-"$(printf %03d ${segment#0})".mp4
    echo 'file "$(printf %03d ${segment#0})".mp4\n' >> files_to_concat
  fi
done
ffmpeg -f concat -safe 0 -i files_to_concat.txt -c copy final_output.mp4

