__global__ void vecAdd(char* a, int width,int height, char* b)
{
	int row=blockIdx.x;
	int id=blockIdx.x*blockDim.x+threadIdx.x;
	int col=threadIdx.x;
if(row==0||row==width-1||col==width-1||col==0)
	{
		b[id]=a[id];
	}
else{
	int sum=0;
	int num=0;

				for(int j=-1;j<=1;j++)
				{
					for(int k=-1;k<=1;k++)
					{
						if (row+j >= 0 && row+j < width && col+k>= 0 && col+k< height)
						{sum=sum+a[(row+j)*height+col+k]; num++;}
					}
				}
				int q=sum/num;

				b[id]=q;

		}

}
#include<stdio.h>
#include<stdlib.h>
#include <stdint.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
#define CHANNEL_NUM 3

int main(int *argc,char *argv[])
{
char* d_a;
char* d_o;
int width, height, bpp;
uint8_t *rgb_image = stbi_load("index.png", &width, &height, &bpp, 1);
/*for(int i=0;i<width;i++)
{
	for(int j=0;j<height;j++)
	{
		printf("%d \t",rgb_image[i*width+j]);
	}
	printf("\n");
}*/
//printf("%d %d %d: \n",rgb_image[0],width,height);
//stbi_image_free(rgb_image);
//int w = 800;
  //  int h = 800;

    //uint8_t* rb_image;
    //rb_image = malloc(width*height*CHANNEL_NUM);

    // Write your code to populate rgb_image here

    //stbi_write_png("image.png", width, height, CHANNEL_NUM, rgb_image, width*CHANNEL_NUM);
//h_a=(int *)malloc(sizeof(int));
//h_b=(int *)malloc(sizeof(int));
//h_c=(int *)malloc(n2*sizeof(int));

cudaMalloc((void **)&d_a, width*height*sizeof(char));
//cudaMalloc((void **)&d_b, sizeof(int));
//cudaMalloc((void **)&d_c, sizeof(int));
cudaMalloc((void **)&d_o, width*height*sizeof(char));
cudaMemcpy( d_a,rgb_image, width*height*sizeof(char), cudaMemcpyHostToDevice);
//cudaMemcpy( d_b, &width, sizeof(int), cudaMemcpyHostToDevice);
//cudaMemcpy( d_c, &height,sizeof(int), cudaMemcpyHostToDevice);

vecAdd<<<height,width>>>(d_a,width,height,d_o);
uint8_t *rb_image;
rb_image = (uint8_t *)malloc(width*height*sizeof(char));

cudaMemcpy( rb_image, d_o,width*height*sizeof(char), cudaMemcpyDeviceToHost);
printf("output ksjsksjsj\n \n \n \n");
for(int i=0;i<width;i++)
{
	for(int j=0;j<height;j++)
	{
		printf("%d \t",rb_image[i*width+j]);
	}
	printf("\n");
}
stbi_write_png("iaa.png", width, height, 1, rb_image, width*1);
stbi_write_png("ima.png", width, height, 1, rgb_image, width*1);
/*for(int i=0;i<n2;i++)
{
	if(i%col1==0&&i!=0)
			printf("\n");
	printf("%d ",h_c[i]);

}*/
}

